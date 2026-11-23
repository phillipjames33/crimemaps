import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

import '../../../core/config/app_env.dart';
import '../../../core/config/compliance_constants.dart';
import '../../../core/geo/geohash_util.dart';
import '../../../core/mock/seed_data.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../domain/incident_model.dart';
import '../domain/incident_repository.dart';

/// Firestore-backed [IncidentRepository] with bounded `geoflutterfire_plus`
/// radius queries and seamless in-memory seeded mock fallback.
class FirestoreIncidentRepository implements IncidentRepository {
  FirestoreIncidentRepository({
    FirebaseFirestore? firestore,
    List<Incident>? initialMockIncidents,
    bool? forceMockMode,
  })  : _firestoreOverride = firestore,
        _forceMockMode = forceMockMode,
        _mockIncidents = List<Incident>.from(
          initialMockIncidents ?? SeedData.buildSeedIncidents(),
        );

  static const String _collectionName = 'incidents';
  static const double _areaRadiusMiles = 5.0;
  static const double _areaRadiusKm = 8.04672;

  final FirebaseFirestore? _firestoreOverride;
  final bool? _forceMockMode;
  final List<Incident> _mockIncidents;
  final StreamController<void> _mockChangesController =
      StreamController<void>.broadcast();

  bool get _useFirestore {
    if (_forceMockMode == true) return false;
    if (_firestoreOverride != null && !AppEnv.useMockData) return true;
    return !AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady;
  }

  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _incidentsCollection =>
      _firestore.collection(_collectionName);

  @override
  Stream<List<Incident>> watchIncidentsInRadius({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    int limit = 100,
  }) {
    if (_useFirestore) {
      final geoRef = GeoCollectionReference<Map<String, dynamic>>(
        _incidentsCollection,
      );
      final center = GeoFirePoint(GeoPoint(centerLat, centerLng));

      return geoRef
          .subscribeWithin(
            center: center,
            radiusInKm: radiusKm,
            field: 'geo',
            geopointFrom: _extractGeoPoint,
            queryBuilder: (Query<Map<String, dynamic>> query) =>
                query.limit(limit),
            strictMode: true,
          )
          .map((List<DocumentSnapshot<Map<String, dynamic>>> snapshots) {
        final incidents = snapshots
            .map(_incidentFromSnapshot)
            .whereType<Incident>()
            .toList()
          ..sort((Incident a, Incident b) => b.occurredAt.compareTo(a.occurredAt));
        return incidents.take(limit).toList();
      });
    }

    return _watchMockIncidents(
      centerLat: centerLat,
      centerLng: centerLng,
      radiusKm: radiusKm,
      limit: limit,
    );
  }

  Stream<List<Incident>> _watchMockIncidents({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    required int limit,
  }) async* {
    List<Incident> compute() {
      final radiusMeters = radiusKm * 1000.0;
      final filtered = _mockIncidents.where((Incident incident) {
        final distanceMeters = GeohashUtil.haversineDistanceMeters(
          lat1: centerLat,
          lng1: centerLng,
          lat2: incident.geo.latitude,
          lng2: incident.geo.longitude,
        );
        return distanceMeters <= radiusMeters;
      }).toList()
        ..sort((Incident a, Incident b) => b.occurredAt.compareTo(a.occurredAt));
      return filtered.take(limit).toList();
    }

    yield compute();
    await for (final _ in _mockChangesController.stream) {
      yield compute();
    }
  }

  @override
  Future<List<Incident>> fetchIncidentsByScope({
    required MapScope scope,
    required double centerLat,
    required double centerLng,
    String? citySlug,
    String? stateCode,
    int limit = 150,
  }) async {
    if (_useFirestore) {
      try {
        return await _fetchFirestoreByScope(
          scope: scope,
          centerLat: centerLat,
          centerLng: centerLng,
          citySlug: citySlug,
          stateCode: stateCode,
          limit: limit,
        );
      } catch (_) {
        // Fall back seamlessly to local mock data if Firestore is unreachable.
      }
    }

    return _fetchMockByScope(
      scope: scope,
      centerLat: centerLat,
      centerLng: centerLng,
      citySlug: citySlug,
      stateCode: stateCode,
      limit: limit,
    );
  }

  Future<List<Incident>> _fetchFirestoreByScope({
    required MapScope scope,
    required double centerLat,
    required double centerLng,
    String? citySlug,
    String? stateCode,
    required int limit,
  }) async {
    switch (scope) {
      case MapScope.area:
        final geoRef = GeoCollectionReference<Map<String, dynamic>>(
          _incidentsCollection,
        );
        final center = GeoFirePoint(GeoPoint(centerLat, centerLng));
        final snapshots = await geoRef.fetchWithin(
          center: center,
          radiusInKm: _areaRadiusKm,
          field: 'geo',
          geopointFrom: _extractGeoPoint,
          queryBuilder: (Query<Map<String, dynamic>> query) =>
              query.limit(limit),
          strictMode: true,
        );
        final incidents = snapshots
            .map(_incidentFromSnapshot)
            .whereType<Incident>()
            .toList()
          ..sort((Incident a, Incident b) => b.occurredAt.compareTo(a.occurredAt));
        return incidents.take(limit).toList();

      case MapScope.city:
        final normalizedCity = (citySlug ?? 'atlanta').toLowerCase();
        final querySnapshot = await _incidentsCollection
            .where('citySlug', isEqualTo: normalizedCity)
            .orderBy('occurredAt', descending: true)
            .limit(limit)
            .get();
        return querySnapshot.docs
            .map(_incidentFromSnapshot)
            .whereType<Incident>()
            .toList();

      case MapScope.state:
        final normalizedState = (stateCode ?? 'GA').toUpperCase();
        final querySnapshot = await _incidentsCollection
            .where('stateCode', isEqualTo: normalizedState)
            .orderBy('occurredAt', descending: true)
            .limit(limit)
            .get();
        return querySnapshot.docs
            .map(_incidentFromSnapshot)
            .whereType<Incident>()
            .toList();
    }
  }

  List<Incident> _fetchMockByScope({
    required MapScope scope,
    required double centerLat,
    required double centerLng,
    String? citySlug,
    String? stateCode,
    required int limit,
  }) {
    final filtered = _mockIncidents.where((Incident incident) {
      switch (scope) {
        case MapScope.area:
          final miles = GeohashUtil.haversineDistanceMiles(
            lat1: centerLat,
            lng1: centerLng,
            lat2: incident.geo.latitude,
            lng2: incident.geo.longitude,
          );
          return miles <= _areaRadiusMiles;
        case MapScope.city:
          if (citySlug == null || citySlug.isEmpty) return true;
          return incident.citySlug.toLowerCase() == citySlug.toLowerCase();
        case MapScope.state:
          if (stateCode == null || stateCode.isEmpty) return true;
          return incident.stateCode.toUpperCase() == stateCode.toUpperCase();
      }
    }).toList()
      ..sort((Incident a, Incident b) => b.occurredAt.compareTo(a.occurredAt));

    return filtered.take(limit).toList();
  }

  @override
  Future<Incident?> getIncidentById(String id) async {
    if (_useFirestore) {
      try {
        final doc = await _incidentsCollection.doc(id).get();
        if (doc.exists) {
          return _incidentFromSnapshot(doc);
        }
      } catch (_) {
        // Fall through to local store.
      }
    }

    for (final incident in _mockIncidents) {
      if (incident.id == id) {
        return incident;
      }
    }
    return null;
  }

  @override
  Future<void> markOffenderRedacted(String incidentId) async {
    final index = _mockIncidents.indexWhere(
      (Incident item) => item.id == incidentId,
    );
    if (index != -1) {
      final existing = _mockIncidents[index];
      final existingOffender = existing.allegedOffender;
      if (existingOffender != null) {
        _mockIncidents[index] = existing.copyWith(
          allegedOffender: existingOffender.copyWith(
            name: 'Record Redacted Pending Review',
            bookingPhotoUrl: null,
            charges: const <String>[],
            disclaimer: ComplianceConstants.presumedInnocentDisclaimer,
            redacted: true,
          ),
        );
        if (!_mockChangesController.isClosed) {
          _mockChangesController.add(null);
        }
      }
    }

    if (_useFirestore) {
      try {
        await _incidentsCollection.doc(incidentId).update(<String, dynamic>{
          'allegedOffender.redacted': true,
          'allegedOffender.bookingPhotoUrl': null,
          'allegedOffender.name': 'Record Redacted Pending Review',
          'allegedOffender.charges': const <String>[],
        });
      } catch (_) {
        // Direct writes to `incidents` are restricted to Admin SDK / Cloud
        // Function (`submitMugshotRemoval`), which handles remote redaction.
      }
    }
  }

  void dispose() {
    if (!_mockChangesController.isClosed) {
      unawaited(_mockChangesController.close());
    }
  }

  GeoPoint _extractGeoPoint(Map<String, dynamic> data) {
    final geo = data['geo'];
    if (geo is Map<String, dynamic>) {
      final geopoint = geo['geopoint'];
      if (geopoint is GeoPoint) {
        return geopoint;
      }
      final lat = geo['latitude'];
      final lng = geo['longitude'];
      if (lat is num && lng is num) {
        return GeoPoint(lat.toDouble(), lng.toDouble());
      }
    }
    return const GeoPoint(0, 0);
  }

  Incident? _incidentFromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) return null;

    try {
      final geoRaw = data['geo'];
      double lat = 0.0;
      double lng = 0.0;
      String geohash = '';

      if (geoRaw is Map<String, dynamic>) {
        final geopoint = geoRaw['geopoint'];
        if (geopoint is GeoPoint) {
          lat = geopoint.latitude;
          lng = geopoint.longitude;
        } else {
          final latVal = geoRaw['latitude'];
          final lngVal = geoRaw['longitude'];
          if (latVal is num) lat = latVal.toDouble();
          if (lngVal is num) lng = lngVal.toDouble();
        }
        final hashVal = geoRaw['geohash'];
        geohash = hashVal is String && hashVal.isNotEmpty
            ? hashVal
            : GeohashUtil.encode(lat, lng, precision: 8);
      }

      final occurredAt = _parseDateTime(data['occurredAt']) ?? DateTime.now().toUtc();
      final expireAt = _parseDateTime(data['expireAt']);
      final allegedOffender = _parseOffender(data['allegedOffender'], occurredAt);

      return Incident(
        id: doc.id,
        title: _asString(data['title'], fallback: 'Public Safety Incident'),
        category: _parseCategory(data['category']),
        severity: _parseSeverity(data['severity']),
        address: _asString(data['address'], fallback: 'Address unavailable'),
        placeName: _asString(data['placeName'], fallback: 'Public Location'),
        placeType: _asString(data['placeType'], fallback: 'public_area'),
        geo: GeoCoordinate(
          latitude: lat,
          longitude: lng,
          geohash: geohash,
        ),
        citySlug: _asString(data['citySlug'], fallback: 'atlanta'),
        cityName: _asString(data['cityName'], fallback: 'Atlanta'),
        stateCode: _asString(data['stateCode'], fallback: 'GA'),
        occurredAt: occurredAt,
        streetViewUrl: data['streetViewUrl'] is String
            ? data['streetViewUrl'] as String
            : AppEnv.buildStreetViewUrl(latitude: lat, longitude: lng),
        sourceAgency: _asString(data['sourceAgency'], fallback: 'Public Dispatch'),
        allegedOffender: allegedOffender,
        expireAt: expireAt ?? allegedOffender?.expiresAt,
      );
    } catch (_) {
      return null;
    }
  }

  AllegedOffender? _parseOffender(Object? raw, DateTime fallbackDate) {
    if (raw is! Map<String, dynamic>) return null;
    final bookingDate = _parseDateTime(raw['bookingDate']) ?? fallbackDate;
    final expiresAt = _parseDateTime(raw['expiresAt']) ??
        ComplianceConstants.computeBookingExpiry(bookingDate);
    final chargesRaw = raw['charges'];
    final charges = chargesRaw is List<dynamic>
        ? chargesRaw.whereType<String>().toList()
        : <String>[];

    return AllegedOffender(
      name: _asString(raw['name'], fallback: 'Public Booking Record'),
      bookingPhotoUrl: raw['bookingPhotoUrl'] is String
          ? raw['bookingPhotoUrl'] as String
          : null,
      charges: charges,
      bookingDate: bookingDate,
      sourceAgency: _asString(raw['sourceAgency'], fallback: 'County Detention'),
      disclaimer: ComplianceConstants.presumedInnocentDisclaimer,
      expiresAt: expiresAt,
      redacted: raw['redacted'] == true,
    );
  }

  DateTime? _parseDateTime(Object? raw) {
    if (raw is Timestamp) return raw.toDate().toUtc();
    if (raw is DateTime) return raw.toUtc();
    if (raw is String) return DateTime.tryParse(raw)?.toUtc();
    return null;
  }

  String _asString(Object? value, {required String fallback}) {
    if (value is String && value.isNotEmpty) return value;
    return fallback;
  }

  IncidentCategory _parseCategory(Object? raw) {
    if (raw is String) {
      switch (raw.toLowerCase()) {
        case 'violent':
          return IncidentCategory.violent;
        case 'property':
          return IncidentCategory.property;
        case 'trafficdui':
        case 'traffic_dui':
          return IncidentCategory.trafficDui;
      }
    }
    return IncidentCategory.other;
  }

  IncidentSeverity _parseSeverity(Object? raw) {
    if (raw is String) {
      switch (raw.toLowerCase()) {
        case 'critical':
          return IncidentSeverity.critical;
        case 'high':
          return IncidentSeverity.high;
        case 'medium':
          return IncidentSeverity.medium;
        case 'low':
          return IncidentSeverity.low;
      }
    }
    return IncidentSeverity.medium;
  }
}
