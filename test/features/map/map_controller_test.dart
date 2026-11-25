import 'package:crime_maps/features/incidents/domain/incident_model.dart';
import 'package:crime_maps/features/incidents/domain/incident_repository.dart';
import 'package:crime_maps/features/incidents/presentation/incident_providers.dart';
import 'package:crime_maps/features/map/presentation/map_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapController', () {
    test('switches between area, city, and state scopes with appropriate zoom',
        () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initial = container.read(mapControllerProvider);
      expect(initial.scope, equals(MapScope.area));
      expect(initial.activeCitySlug, equals('atlanta'));
      expect(initial.activeStateCode, equals('GA'));

      final notifier = container.read(mapControllerProvider.notifier);

      notifier.setScope(MapScope.city);
      expect(container.read(mapControllerProvider).scope, equals(MapScope.city));
      expect(container.read(mapControllerProvider).zoom, equals(11.5));

      notifier.setScope(MapScope.state);
      expect(
        container.read(mapControllerProvider).scope,
        equals(MapScope.state),
      );
      expect(container.read(mapControllerProvider).zoom, equals(6.8));
      expect(container.read(mapControllerProvider).tilt, equals(0.0));

      notifier.setScope(MapScope.area);
      expect(container.read(mapControllerProvider).scope, equals(MapScope.area));
      expect(container.read(mapControllerProvider).zoom, equals(13.5));
      expect(container.read(mapControllerProvider).tilt, equals(45.0));
    });

    test('switches city presets directly and via search query match', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(mapControllerProvider.notifier);

      final chicago = MapController.cityPresets.firstWhere(
        (CityPreset p) => p.citySlug == 'chicago',
      );
      notifier.selectCityPreset(chicago);

      final chicagoState = container.read(mapControllerProvider);
      expect(chicagoState.activeCitySlug, equals('chicago'));
      expect(chicagoState.activeCityName, equals('Chicago'));
      expect(chicagoState.activeStateCode, equals('IL'));
      expect(chicagoState.activeZipCode, equals('60601'));
      expect(chicagoState.centerLat, equals(chicago.latitude));
      expect(chicagoState.centerLng, equals(chicago.longitude));

      // Jump by slug
      expect(notifier.selectCityBySlug('houston'), isTrue);
      expect(
        container.read(mapControllerProvider).activeCitySlug,
        equals('houston'),
      );
      expect(
        container.read(mapControllerProvider).activeStateCode,
        equals('TX'),
      );

      // Jump by ZIP code via submitSearch
      notifier.submitSearch('90028');
      expect(
        container.read(mapControllerProvider).activeCitySlug,
        equals('los_angeles'),
      );
      expect(
        container.read(mapControllerProvider).activeStateCode,
        equals('CA'),
      );
    });

    test('toggles map overlay layers and car-nav follow mode', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(mapControllerProvider.notifier);

      expect(
        container.read(mapControllerProvider).showTerritoriesLayer,
        isTrue,
      );
      notifier.toggleTerritoriesLayer();
      expect(
        container.read(mapControllerProvider).showTerritoriesLayer,
        isFalse,
      );

      expect(container.read(mapControllerProvider).showCamerasLayer, isTrue);
      notifier.toggleCamerasLayer();
      expect(container.read(mapControllerProvider).showCamerasLayer, isFalse);

      expect(
        container.read(mapControllerProvider).showResidentialDensityLayer,
        isFalse,
      );
      notifier.toggleResidentialDensityLayer();
      expect(
        container.read(mapControllerProvider).showResidentialDensityLayer,
        isTrue,
      );

      expect(container.read(mapControllerProvider).showIncidentsLayer, isTrue);
      notifier.toggleIncidentsLayer();
      expect(container.read(mapControllerProvider).showIncidentsLayer, isFalse);

      expect(container.read(mapControllerProvider).carFollowMode, isTrue);
      notifier.toggleCarFollowMode();
      expect(container.read(mapControllerProvider).carFollowMode, isFalse);
      expect(container.read(mapControllerProvider).tilt, equals(0.0));
    });

    test('filters scopedIncidents by category and highSeverityOnly cleanly',
        () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(mapControllerProvider.notifier);
      notifier.setScope(MapScope.city);

      final allAtlanta = await container.read(scopedIncidentsProvider.future);
      expect(allAtlanta, isNotEmpty);

      notifier.setCategoryFilter(IncidentCategory.violent);
      final violentOnly = await container.read(scopedIncidentsProvider.future);
      expect(violentOnly, isNotEmpty);
      expect(
        violentOnly.every((Incident i) => i.category == IncidentCategory.violent),
        isTrue,
      );

      notifier.setCategoryFilter(null);
      notifier.toggleHighSeverityOnly();
      final highCritOnly = await container.read(scopedIncidentsProvider.future);
      expect(highCritOnly, isNotEmpty);
      expect(
        highCritOnly.every(
          (Incident i) =>
              i.severity == IncidentSeverity.high ||
              i.severity == IncidentSeverity.critical,
        ),
        isTrue,
      );

      notifier.clearIncidentFilters();
      final reset = container.read(mapControllerProvider);
      expect(reset.selectedCategory, isNull);
      expect(reset.highSeverityOnly, isFalse);
      expect(reset.searchQuery, isEmpty);
    });
  });
}
