import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_service.g.dart';

/// Immutable GPS telemetry snapshot exposed to presentation layers so UI
/// widgets never import `geolocator` directly.
class UserLocationFix {
  const UserLocationFix({
    required this.latitude,
    required this.longitude,
    this.heading = 0.0,
    this.speedMps = 0.0,
    this.accuracyMeters = 10.0,
    this.isSimulated = false,
  });

  final double latitude;
  final double longitude;
  final double heading;
  final double speedMps;
  final double accuracyMeters;
  final bool isSimulated;

  /// Default Atlanta Midtown fallback coordinates for emulator/mock runs.
  static const UserLocationFix atlantaDefault = UserLocationFix(
    latitude: 33.7756,
    longitude: -84.3963,
    heading: 18.0,
    speedMps: 11.2,
    accuracyMeters: 8.0,
    isSimulated: true,
  );
}

/// Abstract location gateway allowing clean test overrides without hardware GPS.
abstract class LocationGateway {
  Future<UserLocationFix> getCurrentLocation();
  Stream<UserLocationFix> watchLocation();
}

class GeolocatorLocationGateway implements LocationGateway {
  @override
  Future<UserLocationFix> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return UserLocationFix.atlantaDefault;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return UserLocationFix.atlantaDefault;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 6),
        ),
      );
      return _mapPosition(pos);
    } catch (_) {
      return UserLocationFix.atlantaDefault;
    }
  }

  @override
  Stream<UserLocationFix> watchLocation() async* {
    final initial = await getCurrentLocation();
    yield initial;

    if (initial.isSimulated) {
      return;
    }

    const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );

    try {
      await for (final pos in Geolocator.getPositionStream(
        locationSettings: settings,
      )) {
        yield _mapPosition(pos);
      }
    } catch (_) {
      yield UserLocationFix.atlantaDefault;
    }
  }

  UserLocationFix _mapPosition(Position pos) {
    return UserLocationFix(
      latitude: pos.latitude,
      longitude: pos.longitude,
      heading: pos.heading.isFinite && pos.heading >= 0 ? pos.heading : 0.0,
      speedMps: pos.speed.isFinite && pos.speed >= 0 ? pos.speed : 0.0,
      accuracyMeters: pos.accuracy,
    );
  }
}

@Riverpod(keepAlive: true)
LocationGateway locationGateway(Ref ref) {
  return GeolocatorLocationGateway();
}

@Riverpod(keepAlive: true)
Stream<UserLocationFix> userLocationStream(Ref ref) {
  final gateway = ref.watch(locationGatewayProvider);
  return gateway.watchLocation();
}
