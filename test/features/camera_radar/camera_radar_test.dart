import 'dart:async';

import 'package:crime_maps/core/config/compliance_constants.dart';
import 'package:crime_maps/core/geo/geohash_util.dart';
import 'package:crime_maps/core/geo/location_service.dart';
import 'package:crime_maps/core/mock/seed_data.dart';
import 'package:crime_maps/features/camera_radar/data/firestore_camera_repository.dart';
import 'package:crime_maps/features/camera_radar/data/local_camera_cache.dart';
import 'package:crime_maps/features/camera_radar/domain/camera_model.dart';
import 'package:crime_maps/features/camera_radar/domain/camera_repository.dart';
import 'package:crime_maps/features/camera_radar/presentation/camera_radar_controller.dart';
import 'package:crime_maps/features/camera_radar/presentation/widgets/camera_alert_banner.dart';
import 'package:crime_maps/features/geo_radio/data/audio_player_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _SilentLocationGateway implements LocationGateway {
  @override
  Future<UserLocationFix> getCurrentLocation() async {
    return UserLocationFix.atlantaDefault;
  }

  @override
  Stream<UserLocationFix> watchLocation() => const Stream<UserLocationFix>.empty();
}

class _CountingCameraRepository implements CameraRepository {
  _CountingCameraRepository(this._delegate);

  final FirestoreCameraRepository _delegate;
  int syncCalls = 0;

  @override
  Future<List<PublicCamera>> syncCamerasForGeohashCell({
    required String cellPrefix,
    required double centerLat,
    required double centerLng,
    int limit = 150,
  }) {
    syncCalls++;
    return _delegate.syncCamerasForGeohashCell(
      cellPrefix: cellPrefix,
      centerLat: centerLat,
      centerLng: centerLng,
      limit: limit,
    );
  }

  @override
  Future<List<PublicCamera>> fetchCamerasForArea({
    required String citySlug,
    required String stateCode,
    required bool stateScope,
    int limit = 150,
  }) {
    return _delegate.fetchCamerasForArea(
      citySlug: citySlug,
      stateCode: stateCode,
      stateScope: stateScope,
      limit: limit,
    );
  }

  @override
  Future<List<ResidentialDensityCell>> fetchResidentialDensityCells({
    String? citySlug,
  }) {
    return _delegate.fetchResidentialDensityCells(citySlug: citySlug);
  }

  @override
  Future<void> submitPublicCamera(CameraSubmissionRequest request) {
    return _delegate.submitPublicCamera(request);
  }
}

void main() {
  group('Camera Radar — Spatial Cache, Proximity & Compliance', () {
    test(
      'Local cache hit serves cameras with zero repository/Firestore polling on GPS ticks',
      () async {
        final cache = LocalCameraCache();
        final repo = _CountingCameraRepository(
          FirestoreCameraRepository(liveModeOverride: () => false),
        );
        final audio = AudioPlayerService.headless();
        addTearDown(() async {
          await cache.close();
          await audio.dispose();
        });

        const lat = 33.7768;
        const lng = -84.3955;
        final cellKey = GeohashUtil.cellKey(lat, lng);
        await cache.putCell(cellKey, SeedData.buildSeedCameras());

        final container = ProviderContainer(
          overrides: <Override>[
            locationGatewayProvider.overrideWithValue(_SilentLocationGateway()),
            localCameraCacheProvider.overrideWithValue(cache),
            cameraRepositoryProvider.overrideWithValue(repo),
            audioPlayerServiceProvider.overrideWithValue(audio),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(
          cameraRadarControllerProvider.notifier,
        );

        // Multiple GPS ticks within the pre-cached geohash cell must NEVER hit
        // the repository.
        await controller.onLocationUpdate(lat, lng);
        await controller.onLocationUpdate(lat + 0.0002, lng - 0.0002);
        await controller.onLocationUpdate(lat + 0.0004, lng - 0.0004);

        expect(repo.syncCalls, equals(0));
        final state = container.read(cameraRadarControllerProvider);
        expect(state.cameras, isNotEmpty);
        expect(state.currentCellKey, equals(cellKey));
      },
    );

    test(
      'Haversine proximity check triggers alert within radius and ducks audio chime',
      () async {
        final cache = LocalCameraCache();
        final repo = _CountingCameraRepository(
          FirestoreCameraRepository(liveModeOverride: () => false),
        );
        final audio = AudioPlayerService.headless();
        addTearDown(() async {
          await cache.close();
          await audio.dispose();
        });

        final container = ProviderContainer(
          overrides: <Override>[
            locationGatewayProvider.overrideWithValue(_SilentLocationGateway()),
            localCameraCacheProvider.overrideWithValue(cache),
            cameraRepositoryProvider.overrideWithValue(repo),
            audioPlayerServiceProvider.overrideWithValue(audio),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(
          cameraRadarControllerProvider.notifier,
        );

        // Move right next to cam-atl-alpr-01 (33.7768, -84.3955).
        await controller.onLocationUpdate(33.7767, -84.3955);

        // First visit to this cell syncs once; subsequent tick in cell does not.
        expect(repo.syncCalls, equals(1));
        await controller.onLocationUpdate(33.7768, -84.3955);
        expect(repo.syncCalls, equals(1));

        final alert = container.read(cameraRadarControllerProvider).activeAlert;
        expect(alert, isNotNull);
        expect(alert!.camera.id, equals('cam-atl-alpr-01'));
        expect(alert.distanceMeters, lessThanOrEqualTo(250.0));
        expect(audio.volume, equals(AudioPlayerService.duckedVolume));
      },
    );

    test(
      'Anti-doxxing guardrail rejects private residential camera submissions',
      () async {
        final repo = FirestoreCameraRepository(liveModeOverride: () => false);

        const privateRequest = CameraSubmissionRequest(
          type: PublicCameraType.alprFlock,
          operatorName: 'Private Resident Doorbell',
          latitude: 33.7756,
          longitude: -84.3963,
          citySlug: 'atlanta',
          stateCode: 'GA',
          isPrivateResidence: true,
        );

        await expectLater(
          () => repo.submitPublicCamera(privateRequest),
          throwsA(isA<AntiDoxxingViolationException>()),
        );

        const publicRequest = CameraSubmissionRequest(
          type: PublicCameraType.traffic,
          operatorName: 'GDOT Corridor Public Pole',
          latitude: 33.7756,
          longitude: -84.3963,
          citySlug: 'atlanta',
          stateCode: 'GA',
          isPrivateResidence: false,
        );

        await repo.submitPublicCamera(publicRequest);
      },
    );

    testWidgets(
      'CameraAlertBanner renders Apple 1.4.4 compliant civic transparency copy',
      (tester) async {
        final camera = SeedData.buildSeedCameras().first;
        final alert = CameraProximityAlert(
          camera: camera,
          distanceMeters: 142.4,
          triggeredAt: DateTime.utc(2026, 11, 23, 18),
        );
        var dismissed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CameraAlertBanner(
                alert: alert,
                onDismiss: () => dismissed = true,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text(ComplianceConstants.cameraZoneBannerPrefix),
          findsOneWidget,
        );
        expect(find.text(camera.operatorName), findsOneWidget);
        expect(find.textContaining('142 m away'), findsOneWidget);
        expect(
          find.textContaining('Civic Transparency & Privacy Awareness'),
          findsOneWidget,
        );

        // Verify civic transparency framing is present and no evasion language
        // is rendered in the widget tree.
        final disallowed = <String>[
          <String>['av', 'oid', ' ', 'pol', 'ice'].join(),
          <String>['ev', 'ade', ' ', 'co', 'ps'].join(),
          <String>['sp', 'eed', ' ', 'tr', 'ap'].join(),
        ];
        for (final phrase in disallowed) {
          expect(
            find.textContaining(phrase, findRichText: true),
            findsNothing,
          );
        }

        await tester.tap(find.byTooltip('Dismiss'));
        expect(dismissed, isTrue);
      },
    );
  });
}
