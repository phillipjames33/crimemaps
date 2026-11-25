import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../map/presentation/map_controller.dart';
import '../data/firestore_incident_repository.dart';
import '../data/jail_booking_adapter.dart';
import '../domain/incident_model.dart';
import '../domain/incident_repository.dart';

part 'incident_providers.g.dart';

@Riverpod(keepAlive: true)
IncidentRepository incidentRepository(Ref ref) {
  final repository = FirestoreIncidentRepository();
  ref.onDispose(repository.dispose);
  return repository;
}

@Riverpod(keepAlive: true)
JailBookingAdapter jailBookingAdapter(Ref ref) {
  return CountyJailBookingAdapter();
}

@riverpod
Future<List<Incident>> scopedIncidents(Ref ref) async {
  final queryParams = ref.watch(
    mapControllerProvider.select(
      (state) => (
        scope: state.scope,
        centerLat: state.centerLat,
        centerLng: state.centerLng,
        citySlug: state.activeCitySlug,
        stateCode: state.activeStateCode,
        searchQuery: state.searchQuery,
        selectedCategory: state.selectedCategory,
        highSeverityOnly: state.highSeverityOnly,
      ),
    ),
  );

  final repository = ref.watch(incidentRepositoryProvider);
  final incidents = await repository.fetchIncidentsByScope(
    scope: queryParams.scope,
    centerLat: queryParams.centerLat,
    centerLng: queryParams.centerLng,
    citySlug: queryParams.citySlug,
    stateCode: queryParams.stateCode,
  );

  final trimmedQuery = queryParams.searchQuery.trim().toLowerCase();
  final selectedCategory = queryParams.selectedCategory;
  final highSeverityOnly = queryParams.highSeverityOnly;

  if (trimmedQuery.isEmpty && selectedCategory == null && !highSeverityOnly) {
    return incidents;
  }

  return incidents.where((Incident incident) {
    if (selectedCategory != null && incident.category != selectedCategory) {
      return false;
    }
    if (highSeverityOnly &&
        incident.severity != IncidentSeverity.high &&
        incident.severity != IncidentSeverity.critical) {
      return false;
    }
    if (trimmedQuery.isEmpty) return true;
    final offenderName =
        (incident.allegedOffender?.redacted == false
                ? incident.allegedOffender?.name
                : null) ??
            '';
    return incident.title.toLowerCase().contains(trimmedQuery) ||
        incident.address.toLowerCase().contains(trimmedQuery) ||
        incident.placeName.toLowerCase().contains(trimmedQuery) ||
        incident.cityName.toLowerCase().contains(trimmedQuery) ||
        incident.stateCode.toLowerCase().contains(trimmedQuery) ||
        incident.sourceAgency.toLowerCase().contains(trimmedQuery) ||
        offenderName.toLowerCase().contains(trimmedQuery);
  }).toList();
}
