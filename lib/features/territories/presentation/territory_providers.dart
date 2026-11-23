import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../incidents/domain/incident_repository.dart';
import '../../map/presentation/map_controller.dart';
import '../data/firestore_territory_repository.dart';
import '../domain/territory_model.dart';
import '../domain/territory_repository.dart';

part 'territory_providers.g.dart';

@Riverpod(keepAlive: true)
TerritoryRepository territoryRepository(Ref ref) {
  return FirestoreTerritoryRepository();
}

@riverpod
Future<List<Territory>> territoriesForArea(Ref ref) async {
  final area = ref.watch(
    mapControllerProvider.select(
      (state) => (
        scope: state.scope,
        citySlug: state.activeCitySlug,
        stateCode: state.activeStateCode,
      ),
    ),
  );

  final repository = ref.watch(territoryRepositoryProvider);
  return repository.fetchTerritories(
    citySlug: area.scope == MapScope.state ? null : area.citySlug,
    stateCode: area.stateCode,
  );
}
