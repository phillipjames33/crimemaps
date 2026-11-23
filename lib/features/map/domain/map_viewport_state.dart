import 'package:freezed_annotation/freezed_annotation.dart';

import '../../incidents/domain/incident_repository.dart';

part 'map_viewport_state.freezed.dart';
part 'map_viewport_state.g.dart';

@freezed
abstract class MapViewportState with _$MapViewportState {
  const factory MapViewportState({
    @Default(MapScope.area) MapScope scope,
    @Default(33.7756) double centerLat,
    @Default(-84.3963) double centerLng,
    @Default(13.5) double zoom,
    @Default(45.0) double tilt,
    @Default(0.0) double bearing,
    @Default('atlanta') String activeCitySlug,
    @Default('Atlanta') String activeCityName,
    @Default('GA') String activeStateCode,
    @Default('30308') String activeZipCode,
    @Default(true) bool carFollowMode,
    @Default(true) bool showIncidentsLayer,
    @Default(true) bool showTerritoriesLayer,
    @Default(true) bool showCamerasLayer,
    @Default(false) bool showResidentialDensityLayer,
    @Default('') String searchQuery,
  }) = _MapViewportState;

  factory MapViewportState.fromJson(Map<String, dynamic> json) =>
      _$MapViewportStateFromJson(json);
}
