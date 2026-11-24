import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../incidents/domain/incident_repository.dart';
import '../../map/presentation/map_controller.dart';
import '../data/firestore_camera_repository.dart';
import '../domain/camera_model.dart';

part 'camera_map_providers.g.dart';

/// Streams/loads publicly documented civic cameras for the active map city or
/// state via [CameraRepository] with an explicit `limit(150)`.
///
/// Uses scoped `.select(...)` on city, state, and scope so map panning, zooming,
/// tilting, and GPS ticks NEVER trigger redundant Firestore reads.
@riverpod
Future<List<PublicCamera>> camerasForMapViewport(Ref ref) async {
  final (
    String citySlug,
    String stateCode,
    MapScope scope,
  ) = ref.watch(
    mapControllerProvider.select(
      (s) => (s.activeCitySlug, s.activeStateCode, s.scope),
    ),
  );

  final repository = ref.watch(cameraRepositoryProvider);
  return repository.fetchCamerasForArea(
    citySlug: citySlug,
    stateCode: stateCode,
    stateScope: scope == MapScope.state,
  );
}
