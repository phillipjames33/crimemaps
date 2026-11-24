import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_env.dart';
import '../../../core/geo/geohash_util.dart';
import '../../../core/mock/seed_data.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../domain/camera_model.dart';
import '../domain/camera_repository.dart';

part 'firestore_camera_repository.g.dart';

/// Thrown when a community report attempts to pin a private residential
/// camera (e.g. an individual doorbell). Exact pinning of private homes is
/// never permitted; only public infrastructure cameras may be mapped.
class AntiDoxxingViolationException implements Exception {
  const AntiDoxxingViolationException([
    this.message =
        'Private residential cameras cannot be pinned. Only public '
        'infrastructure cameras (ALPR, traffic, red-light) may be reported.',
  ]);

  final String message;

  @override
  String toString() => 'AntiDoxxingViolationException: $message';
}

/// Firestore-backed [CameraRepository] with a seeded offline fallback.
///
/// * Live mode (`!AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady`):
///   geohash bounding-box query (`geoflutterfire_plus`) with a hard `limit()`.
/// * Otherwise: seeded public cameras from [SeedData].
///
/// This repository is called only when the user crosses into a new geohash
/// cell, never on individual GPS ticks.
class FirestoreCameraRepository implements CameraRepository {
  FirestoreCameraRepository({
    FirebaseFirestore? firestore,
    bool Function()? liveModeOverride,
  })  : _firestore = firestore,
        _liveModeOverride = liveModeOverride;

  static const String camerasCollection = 'cameras';
  static const double _syncRadiusKm = 6.0;

  final FirebaseFirestore? _firestore;
  final bool Function()? _liveModeOverride;
  final List<PublicCamera> _communityCameras = <PublicCamera>[];

  bool get _isLive =>
      _liveModeOverride?.call() ??
      (!AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady);

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<PublicCamera>> syncCamerasForGeohashCell({
    required String cellPrefix,
    required double centerLat,
    required double centerLng,
    int limit = 150,
  }) async {
    if (_isLive) {
      try {
        final live = await _fetchLive(
          centerLat: centerLat,
          centerLng: centerLng,
          limit: limit,
        );
        return live;
      } catch (_) {
        // Fall through to seeded data so the radar still works offline.
      }
    }
    return _seedWithin(
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
  }) async {
    final normalizedCity = citySlug.trim().toLowerCase();
    final normalizedState = stateCode.trim().toUpperCase();

    if (_isLive) {
      try {
        Query<Map<String, dynamic>> query = _db.collection(camerasCollection);
        if (stateScope && normalizedState.isNotEmpty) {
          query = query.where('stateCode', isEqualTo: normalizedState);
        } else if (normalizedCity.isNotEmpty) {
          query = query.where('citySlug', isEqualTo: normalizedCity);
        }
        final snapshot = await query.limit(limit).get();
        final live = <PublicCamera>[];
        for (final doc in snapshot.docs) {
          final camera = cameraFromFirestore(doc.id, doc.data());
          if (camera != null) live.add(camera);
        }
        if (live.isNotEmpty) {
          return live;
        }
      } catch (_) {
        // Fall through to seeded civic cameras when offline or unindexed.
      }
    }

    final all = <PublicCamera>[
      ...SeedData.buildSeedCameras(),
      ..._communityCameras,
    ];
    return all
        .where((PublicCamera cam) {
          if (stateScope) {
            return cam.stateCode.toUpperCase() == normalizedState;
          }
          return cam.citySlug.toLowerCase() == normalizedCity;
        })
        .take(limit)
        .toList(growable: false);
  }

  Future<List<PublicCamera>> _fetchLive({
    required double centerLat,
    required double centerLng,
    required int limit,
  }) async {
    final collection = GeoCollectionReference<Map<String, dynamic>>(
      _db.collection(camerasCollection),
    );
    final snapshots = await collection.fetchWithin(
      center: GeoFirePoint(GeoPoint(centerLat, centerLng)),
      radiusInKm: _syncRadiusKm,
      field: 'geo',
      geopointFrom: (data) =>
          (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
      queryBuilder: (query) => query.limit(limit),
      strictMode: true,
    );

    final cameras = <PublicCamera>[];
    for (final snapshot in snapshots) {
      final data = snapshot.data();
      if (data == null) continue;
      final camera = cameraFromFirestore(snapshot.id, data);
      if (camera != null) cameras.add(camera);
    }
    return cameras.take(limit).toList(growable: false);
  }

  List<PublicCamera> _seedWithin({
    required double centerLat,
    required double centerLng,
    required int limit,
  }) {
    final all = <PublicCamera>[
      ...SeedData.buildSeedCameras(),
      ..._communityCameras,
    ];
    const radiusMeters = _syncRadiusKm * 1000;
    final within = all.where((camera) {
      final distance = GeohashUtil.haversineDistanceMeters(
        lat1: centerLat,
        lng1: centerLng,
        lat2: camera.latitude,
        lng2: camera.longitude,
      );
      return distance <= radiusMeters;
    }).toList();
    return within.take(limit).toList(growable: false);
  }

  @override
  Future<List<ResidentialDensityCell>> fetchResidentialDensityCells({
    String? citySlug,
  }) async {
    // Residential data is ONLY ever exposed as anonymized neighborhood-level
    // density cells (never individual pins).
    return SeedData.buildSeedResidentialDensityCells();
  }

  @override
  Future<void> submitPublicCamera(CameraSubmissionRequest request) async {
    if (request.isPrivateResidence) {
      throw const AntiDoxxingViolationException();
    }
    if (request.operatorName.trim().isEmpty) {
      throw ArgumentError.value(
        request.operatorName,
        'operatorName',
        'Operator / agency name is required.',
      );
    }

    final geohash = GeohashUtil.encode(
      request.latitude,
      request.longitude,
      precision: 8,
    );

    if (_isLive) {
      final geoPoint = GeoPoint(request.latitude, request.longitude);
      await _db.collection(camerasCollection).add(<String, dynamic>{
        'type': publicCameraTypeToJson(request.type),
        'operatorName': request.operatorName.trim(),
        'latitude': request.latitude,
        'longitude': request.longitude,
        'geo': <String, dynamic>{
          'geohash': geohash,
          'geopoint': geoPoint,
          'latitude': request.latitude,
          'longitude': request.longitude,
        },
        'verified': false,
        'source': 'community',
        'isPrivateResidence': false,
        'citySlug': request.citySlug,
        'stateCode': request.stateCode,
        'updatedAt': FieldValue.serverTimestamp(),
        // `streetNotes` is intentionally never persisted (anti-doxxing).
      });
      return;
    }

    _communityCameras.add(
      PublicCamera(
        id: 'community-${DateTime.now().microsecondsSinceEpoch}',
        type: request.type,
        operatorName: request.operatorName.trim(),
        latitude: request.latitude,
        longitude: request.longitude,
        geohash: geohash,
        verified: false,
        source: CameraSource.community,
        citySlug: request.citySlug,
        stateCode: request.stateCode,
        updatedAt: DateTime.now().toUtc(),
      ),
    );
  }

  /// Maps a Firestore camera document to a [PublicCamera]. Returns `null` for
  /// malformed documents and for any private residential entries.
  static PublicCamera? cameraFromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    if (data['isPrivateResidence'] == true) return null;
    try {
      final geo = data['geo'] as Map<String, dynamic>?;
      final geoPoint = geo?['geopoint'];
      double? lat;
      double? lng;
      if (geoPoint is GeoPoint) {
        lat = geoPoint.latitude;
        lng = geoPoint.longitude;
      } else {
        lat = (data['latitude'] as num?)?.toDouble();
        lng = (data['longitude'] as num?)?.toDouble();
      }
      if (lat == null || lng == null) return null;

      final updated = data['updatedAt'];
      final String updatedIso;
      if (updated is Timestamp) {
        updatedIso = updated.toDate().toUtc().toIso8601String();
      } else if (updated is String) {
        updatedIso = updated;
      } else {
        updatedIso = DateTime.now().toUtc().toIso8601String();
      }

      return PublicCamera.fromJson(<String, dynamic>{
        'id': id,
        'type': data['type'],
        'operatorName': data['operatorName'] ?? 'Public Infrastructure',
        'latitude': lat,
        'longitude': lng,
        'geohash':
            (geo?['geohash'] as String?) ??
            GeohashUtil.encode(lat, lng, precision: 8),
        'directionHeading': (data['directionHeading'] as num?)?.toDouble(),
        'verified': data['verified'] ?? true,
        'source': data['source'] ?? 'osm_deflock',
        'citySlug': data['citySlug'] ?? '',
        'stateCode': data['stateCode'] ?? '',
        'updatedAt': updatedIso,
      });
    } catch (_) {
      return null;
    }
  }

  /// Firestore / JSON wire value for a [PublicCameraType].
  static String publicCameraTypeToJson(PublicCameraType type) {
    switch (type) {
      case PublicCameraType.alprFlock:
        return 'alpr_flock';
      case PublicCameraType.traffic:
        return 'traffic';
      case PublicCameraType.redLight:
        return 'red_light';
    }
  }
}

@Riverpod(keepAlive: true)
CameraRepository cameraRepository(Ref ref) {
  return FirestoreCameraRepository();
}
