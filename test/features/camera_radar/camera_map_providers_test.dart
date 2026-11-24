import 'package:crime_maps/features/camera_radar/data/firestore_camera_repository.dart';
import 'package:crime_maps/features/camera_radar/domain/camera_model.dart';
import 'package:crime_maps/features/camera_radar/presentation/camera_map_providers.dart';
import 'package:crime_maps/features/incidents/domain/incident_repository.dart';
import 'package:crime_maps/features/map/presentation/map_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('camerasForMapViewportProvider & fetchCamerasForArea', () {
    test(
      'loads civic cameras for active city and expands in state scope without GPS polling',
      () async {
        final repo = FirestoreCameraRepository(liveModeOverride: () => false);
        final container = ProviderContainer(
          overrides: [
            cameraRepositoryProvider.overrideWithValue(repo),
          ],
        );
        addTearDown(container.dispose);

        // Default city is Atlanta, GA
        final atlantaCameras =
            await container.read(camerasForMapViewportProvider.future);
        expect(atlantaCameras, isNotEmpty);
        expect(
          atlantaCameras.every((PublicCamera c) => c.citySlug == 'atlanta'),
          isTrue,
        );

        // Switch to State scope (GA) -> includes Atlanta + Savannah civic cameras
        container
            .read(mapControllerProvider.notifier)
            .setScope(MapScope.state);
        final georgiaCameras =
            await container.read(camerasForMapViewportProvider.future);
        expect(georgiaCameras.length, greaterThanOrEqualTo(atlantaCameras.length));
        expect(
          georgiaCameras.every((PublicCamera c) => c.stateCode == 'GA'),
          isTrue,
        );
      },
    );
  });
}
