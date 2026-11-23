import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/geo/geohash_util.dart';
import '../../../core/geo/location_service.dart';
import '../../../core/mock/seed_data.dart';
import '../../geo_radio/data/audio_player_service.dart';
import '../data/firestore_camera_repository.dart';
import '../data/local_camera_cache.dart';
import '../domain/camera_model.dart';
import '../domain/camera_repository.dart';

part 'camera_radar_controller.g.dart';

/// Immutable UI state for the Civic Camera Transparency feature.
class CameraRadarState {
  const CameraRadarState({
    this.cameras = const <PublicCamera>[],
    this.settings = const CameraAlertSettings(),
    this.activeAlert,
    this.densityCells = const <ResidentialDensityCell>[],
    this.currentCellKey,
    this.userLatitude,
    this.userLongitude,
    this.cellSyncCount = 0,
    this.isSyncing = false,
  });

  /// Public infrastructure cameras cached for the current geohash cell.
  final List<PublicCamera> cameras;
  final CameraAlertSettings settings;
  final CameraProximityAlert? activeAlert;

  /// Anonymized neighborhood-level residential density cells (never pins).
  final List<ResidentialDensityCell> densityCells;
  final String? currentCellKey;
  final double? userLatitude;
  final double? userLongitude;

  /// Number of times a geohash cell sync (cache lookup / repository fetch)
  /// was performed. Never increments on plain GPS ticks within a cell.
  final int cellSyncCount;
  final bool isSyncing;

  CameraRadarState copyWith({
    List<PublicCamera>? cameras,
    CameraAlertSettings? settings,
    CameraProximityAlert? activeAlert,
    bool clearAlert = false,
    List<ResidentialDensityCell>? densityCells,
    String? currentCellKey,
    double? userLatitude,
    double? userLongitude,
    int? cellSyncCount,
    bool? isSyncing,
  }) {
    return CameraRadarState(
      cameras: cameras ?? this.cameras,
      settings: settings ?? this.settings,
      activeAlert: clearAlert ? null : (activeAlert ?? this.activeAlert),
      densityCells: densityCells ?? this.densityCells,
      currentCellKey: currentCellKey ?? this.currentCellKey,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      cellSyncCount: cellSyncCount ?? this.cellSyncCount,
      isSyncing: isSyncing ?? this.isSyncing,
    );
  }
}

/// Manages the local public-camera cache, alert settings and proximity alerts.
///
/// GPS ticks are evaluated purely locally (Haversine against the cached
/// cameras of the current geohash cell). Firestore is only consulted when the
/// user enters a geohash cell that is not already in [LocalCameraCache].
@Riverpod(keepAlive: true)
class CameraRadarController extends _$CameraRadarController {
  final Set<String> _insideCameraIds = <String>{};
  Future<void>? _inFlightSync;
  bool _disposed = false;

  @override
  CameraRadarState build() {
    _disposed = false;
    ref.onDispose(() => _disposed = true);

    // Scoped select: only lat/lng changes re-run the local proximity check.
    ref.listen<({double lat, double lng})?>(
      userLocationStreamProvider.select((fix) {
        final value = fix.valueOrNull;
        if (value == null) return null;
        return (lat: value.latitude, lng: value.longitude);
      }),
      (previous, next) {
        if (next != null) {
          unawaited(onLocationUpdate(next.lat, next.lng));
        }
      },
      fireImmediately: true,
    );

    unawaited(_loadDensityCells());
    return const CameraRadarState();
  }

  CameraRepository get _repository => ref.read(cameraRepositoryProvider);
  LocalCameraCache get _cache => ref.read(localCameraCacheProvider);

  Future<void> _loadDensityCells() async {
    try {
      final cells = await _repository.fetchResidentialDensityCells();
      if (_disposed) return;
      state = state.copyWith(densityCells: cells);
    } catch (_) {
      // Density overlay is optional; ignore failures.
    }
  }

  /// Handles a GPS fix. Syncs the cache only if the geohash cell changed, then
  /// evaluates local proximity.
  Future<void> onLocationUpdate(double latitude, double longitude) async {
    if (_disposed) return;
    final cellKey = GeohashUtil.cellKey(latitude, longitude);
    state = state.copyWith(userLatitude: latitude, userLongitude: longitude);

    if (cellKey != state.currentCellKey) {
      await _syncCell(cellKey, latitude, longitude);
    } else if (_inFlightSync != null) {
      await _inFlightSync;
    }
    if (_disposed) return;
    _evaluateProximity(latitude, longitude);
  }

  Future<void> _syncCell(String cellKey, double lat, double lng) async {
    final pending = _inFlightSync;
    if (pending != null) {
      await pending;
      if (state.currentCellKey == cellKey) return;
    }
    if (_disposed) return;
    final future = _doSyncCell(cellKey, lat, lng);
    final tracked = future.whenComplete(() => _inFlightSync = null);
    _inFlightSync = tracked;
    await tracked;
  }

  Future<void> _doSyncCell(String cellKey, double lat, double lng) async {
    state = state.copyWith(isSyncing: true);
    List<PublicCamera>? cameras = _cache.getCell(cellKey);
    if (cameras == null) {
      try {
        cameras = await _repository.syncCamerasForGeohashCell(
          cellPrefix: cellKey,
          centerLat: lat,
          centerLng: lng,
        );
        await _cache.putCell(cellKey, cameras);
      } catch (_) {
        cameras = const <PublicCamera>[];
      }
    }
    if (_disposed) return;
    state = state.copyWith(
      cameras: cameras,
      currentCellKey: cellKey,
      cellSyncCount: state.cellSyncCount + 1,
      isSyncing: false,
    );
  }

  /// Local Haversine check against cached cameras; no network access.
  void _evaluateProximity(double lat, double lng) {
    final settings = state.settings;
    if (!settings.enabled) {
      _insideCameraIds.clear();
      if (state.activeAlert != null) {
        state = state.copyWith(clearAlert: true);
      }
      return;
    }

    PublicCamera? nearest;
    var nearestDistance = double.infinity;
    final inside = <String>{};
    for (final camera in state.cameras) {
      final distance = GeohashUtil.haversineDistanceMeters(
        lat1: lat,
        lng1: lng,
        lat2: camera.latitude,
        lng2: camera.longitude,
      );
      if (distance <= settings.radiusMeters) {
        inside.add(camera.id);
        if (distance < nearestDistance) {
          nearest = camera;
          nearestDistance = distance;
        }
      }
    }

    final entered = inside.difference(_insideCameraIds);
    _insideCameraIds
      ..clear()
      ..addAll(inside);

    if (nearest == null) {
      if (state.activeAlert != null) {
        state = state.copyWith(clearAlert: true);
      }
      return;
    }

    if (entered.isNotEmpty) {
      _emitAlert(nearest, nearestDistance);
    } else if (state.activeAlert != null &&
        state.activeAlert!.camera.id == nearest.id) {
      // Keep the visible distance fresh while staying inside the same zone.
      state = state.copyWith(
        activeAlert: CameraProximityAlert(
          camera: nearest,
          distanceMeters: nearestDistance,
          triggeredAt: state.activeAlert!.triggeredAt,
        ),
      );
    }
  }

  void _emitAlert(PublicCamera camera, double distanceMeters) {
    state = state.copyWith(
      activeAlert: CameraProximityAlert(
        camera: camera,
        distanceMeters: distanceMeters,
        triggeredAt: DateTime.now().toUtc(),
      ),
    );
    if (state.settings.audioChime) {
      ref.read(audioPlayerServiceProvider).duckForCameraChime();
    }
  }

  /// Demo/testing helper: forces a proximity evaluation against the nearest
  /// cached public camera, even if it lies outside the configured radius.
  Future<void> simulateProximityCheck({
    double? latitude,
    double? longitude,
  }) async {
    final lat = latitude ?? state.userLatitude ?? UserLocationFix.atlantaDefault.latitude;
    final lng = longitude ?? state.userLongitude ?? UserLocationFix.atlantaDefault.longitude;

    final cellKey = GeohashUtil.cellKey(lat, lng);
    if (cellKey != state.currentCellKey || state.cameras.isEmpty) {
      await _syncCell(cellKey, lat, lng);
    }
    if (_disposed) return;

    var candidates = state.cameras;
    if (candidates.isEmpty) {
      candidates = SeedData.buildSeedCameras();
    }

    PublicCamera? nearest;
    var nearestDistance = double.infinity;
    for (final camera in candidates) {
      final distance = GeohashUtil.haversineDistanceMeters(
        lat1: lat,
        lng1: lng,
        lat2: camera.latitude,
        lng2: camera.longitude,
      );
      if (distance < nearestDistance) {
        nearest = camera;
        nearestDistance = distance;
      }
    }
    if (nearest == null) return;
    _insideCameraIds.add(nearest.id);
    _emitAlert(nearest, nearestDistance);
  }

  /// Hides the banner without re-triggering until the zone is re-entered.
  void dismissAlert() {
    if (state.activeAlert != null) {
      state = state.copyWith(clearAlert: true);
    }
  }

  void setEnabled({required bool enabled}) {
    state = state.copyWith(
      settings: _settingsCopy(enabled: enabled),
      clearAlert: !enabled,
    );
    if (!enabled) _insideCameraIds.clear();
  }

  void setAudioChime({required bool enabled}) {
    state = state.copyWith(settings: _settingsCopy(audioChime: enabled));
  }

  void setRadiusMeters(double radiusMeters) {
    state = state.copyWith(
      settings: _settingsCopy(radiusMeters: radiusMeters.clamp(100.0, 500.0)),
    );
  }

  void setShowResidentialDensityHeatmap({required bool enabled}) {
    state = state.copyWith(
      settings: _settingsCopy(showResidentialDensityHeatmap: enabled),
    );
  }

  CameraAlertSettings _settingsCopy({
    bool? enabled,
    bool? audioChime,
    double? radiusMeters,
    bool? showResidentialDensityHeatmap,
  }) {
    final current = state.settings;
    return CameraAlertSettings(
      enabled: enabled ?? current.enabled,
      audioChime: audioChime ?? current.audioChime,
      radiusMeters: radiusMeters ?? current.radiusMeters,
      showResidentialDensityHeatmap:
          showResidentialDensityHeatmap ?? current.showResidentialDensityHeatmap,
    );
  }

  /// Submits a public infrastructure camera report. Returns `null` on success
  /// or a human-readable error (e.g. anti-doxxing rejection).
  Future<String?> submitPublicCamera(CameraSubmissionRequest request) async {
    try {
      await _repository.submitPublicCamera(request);
      // Re-sync the current cell (one-off) so the report can appear locally.
      final cell = state.currentCellKey;
      final lat = state.userLatitude;
      final lng = state.userLongitude;
      if (cell != null && lat != null && lng != null) {
        await _cache.evictCell(cell);
        await _syncCell(cell, lat, lng);
      }
      return null;
    } on AntiDoxxingViolationException catch (e) {
      return e.message;
    } on ArgumentError catch (e) {
      return e.message?.toString() ?? 'Invalid submission.';
    } catch (_) {
      return 'Could not submit the report right now. Please try again.';
    }
  }
}
