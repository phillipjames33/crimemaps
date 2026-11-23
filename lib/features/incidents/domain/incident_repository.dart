import 'incident_model.dart';

enum MapScope {
  area,
  city,
  state,
}

/// Repository contract for querying public crime incidents using bounded
/// geohash queries with explicit limits.
abstract class IncidentRepository {
  Stream<List<Incident>> watchIncidentsInRadius({
    required double centerLat,
    required double centerLng,
    required double radiusKm,
    int limit = 100,
  });

  Future<List<Incident>> fetchIncidentsByScope({
    required MapScope scope,
    required double centerLat,
    required double centerLng,
    String? citySlug,
    String? stateCode,
    int limit = 150,
  });

  Future<Incident?> getIncidentById(String id);

  /// Redacts alleged offender booking data locally/remotely after a free
  /// removal request is submitted.
  Future<void> markOffenderRedacted(String incidentId);
}

/// Pluggable county jail / booking aggregator adapter contract
/// (supports official county jail APIs or aggregators like americastopmugshot).
abstract class JailBookingAdapter {
  Future<AllegedOffender?> lookupBookingForIncident({
    required String incidentId,
    required String citySlug,
    required String stateCode,
  });
}
