import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../incidents/domain/incident_repository.dart';
import '../domain/map_viewport_state.dart';

part 'map_controller.g.dart';

/// Immutable preset city anchor used for instant car-nav city jumping and
/// nationwide zoom demonstration.
class CityPreset {
  const CityPreset({
    required this.citySlug,
    required this.cityName,
    required this.stateCode,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
  });

  final String citySlug;
  final String cityName;
  final String stateCode;
  final String zipCode;
  final double latitude;
  final double longitude;

  String get displayLabel => '$cityName, $stateCode';
}

/// Manages car-navigation map viewport state, scope switching (`area`/`city`/`state`),
/// city quick-jump presets, search filtering, and overlay layer toggles.
@Riverpod(keepAlive: true)
class MapController extends _$MapController {
  static const List<CityPreset> cityPresets = <CityPreset>[
    CityPreset(
      citySlug: 'atlanta',
      cityName: 'Atlanta',
      stateCode: 'GA',
      zipCode: '30308',
      latitude: 33.7756,
      longitude: -84.3963,
    ),
    CityPreset(
      citySlug: 'savannah',
      cityName: 'Savannah',
      stateCode: 'GA',
      zipCode: '31401',
      latitude: 32.0809,
      longitude: -81.0912,
    ),
    CityPreset(
      citySlug: 'chicago',
      cityName: 'Chicago',
      stateCode: 'IL',
      zipCode: '60601',
      latitude: 41.8858,
      longitude: -87.6279,
    ),
    CityPreset(
      citySlug: 'los_angeles',
      cityName: 'Los Angeles',
      stateCode: 'CA',
      zipCode: '90028',
      latitude: 34.1022,
      longitude: -118.3387,
    ),
    CityPreset(
      citySlug: 'houston',
      cityName: 'Houston',
      stateCode: 'TX',
      zipCode: '77027',
      latitude: 29.7418,
      longitude: -95.4581,
    ),
  ];

  @override
  MapViewportState build() {
    return const MapViewportState();
  }

  void setScope(MapScope scope) {
    final targetZoom = _zoomForScope(scope);
    final targetTilt = _tiltForScope(scope, carFollowMode: state.carFollowMode);
    state = state.copyWith(
      scope: scope,
      zoom: targetZoom,
      tilt: targetTilt,
    );
  }

  void selectCityPreset(CityPreset preset) {
    state = state.copyWith(
      centerLat: preset.latitude,
      centerLng: preset.longitude,
      activeCitySlug: preset.citySlug,
      activeCityName: preset.cityName,
      activeStateCode: preset.stateCode,
      activeZipCode: preset.zipCode,
      zoom: _zoomForScope(state.scope),
      tilt: _tiltForScope(state.scope, carFollowMode: state.carFollowMode),
      searchQuery: '',
    );
  }

  bool selectCityBySlug(String citySlug) {
    final normalized = citySlug.trim().toLowerCase();
    for (final preset in cityPresets) {
      if (preset.citySlug == normalized) {
        selectCityPreset(preset);
        return true;
      }
    }
    return false;
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Checks whether [query] matches a known city preset (name, slug, or ZIP)
  /// and jumps the viewport if matched; otherwise applies it as an incident
  /// search filter.
  void submitSearch(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      state = state.copyWith(searchQuery: '');
      return;
    }

    for (final preset in cityPresets) {
      if (preset.cityName.toLowerCase() == normalized ||
          preset.citySlug == normalized ||
          preset.zipCode == normalized ||
          preset.displayLabel.toLowerCase() == normalized) {
        selectCityPreset(preset);
        return;
      }
    }

    state = state.copyWith(searchQuery: query.trim());
  }

  void updateCameraPosition({
    required double latitude,
    required double longitude,
    double? zoom,
    double? tilt,
    double? bearing,
  }) {
    state = state.copyWith(
      centerLat: latitude,
      centerLng: longitude,
      zoom: zoom ?? state.zoom,
      tilt: tilt ?? state.tilt,
      bearing: bearing ?? state.bearing,
    );
  }

  void updateFromUserLocation({
    required double latitude,
    required double longitude,
    double? heading,
  }) {
    if (!state.carFollowMode) return;
    state = state.copyWith(
      centerLat: latitude,
      centerLng: longitude,
      bearing: heading ?? state.bearing,
    );
  }

  void toggleCarFollowMode() {
    final nextFollow = !state.carFollowMode;
    state = state.copyWith(
      carFollowMode: nextFollow,
      tilt: _tiltForScope(state.scope, carFollowMode: nextFollow),
    );
  }

  void toggleIncidentsLayer() {
    state = state.copyWith(showIncidentsLayer: !state.showIncidentsLayer);
  }

  void toggleTerritoriesLayer() {
    state = state.copyWith(showTerritoriesLayer: !state.showTerritoriesLayer);
  }

  void toggleCamerasLayer() {
    state = state.copyWith(showCamerasLayer: !state.showCamerasLayer);
  }

  void toggleResidentialDensityLayer() {
    state = state.copyWith(
      showResidentialDensityLayer: !state.showResidentialDensityLayer,
    );
  }

  double _zoomForScope(MapScope scope) {
    switch (scope) {
      case MapScope.area:
        return 13.5;
      case MapScope.city:
        return 11.5;
      case MapScope.state:
        return 6.8;
    }
  }

  double _tiltForScope(MapScope scope, {required bool carFollowMode}) {
    if (!carFollowMode) return 0.0;
    switch (scope) {
      case MapScope.area:
        return 45.0;
      case MapScope.city:
        return 30.0;
      case MapScope.state:
        return 0.0;
    }
  }
}
