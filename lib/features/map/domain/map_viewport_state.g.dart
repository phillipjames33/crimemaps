// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_viewport_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MapViewportState _$MapViewportStateFromJson(
  Map<String, dynamic> json,
) => _MapViewportState(
  scope: $enumDecodeNullable(_$MapScopeEnumMap, json['scope']) ?? MapScope.area,
  centerLat: (json['centerLat'] as num?)?.toDouble() ?? 33.7756,
  centerLng: (json['centerLng'] as num?)?.toDouble() ?? -84.3963,
  zoom: (json['zoom'] as num?)?.toDouble() ?? 13.5,
  tilt: (json['tilt'] as num?)?.toDouble() ?? 45.0,
  bearing: (json['bearing'] as num?)?.toDouble() ?? 0.0,
  activeCitySlug: json['activeCitySlug'] as String? ?? 'atlanta',
  activeCityName: json['activeCityName'] as String? ?? 'Atlanta',
  activeStateCode: json['activeStateCode'] as String? ?? 'GA',
  activeZipCode: json['activeZipCode'] as String? ?? '30308',
  carFollowMode: json['carFollowMode'] as bool? ?? true,
  showIncidentsLayer: json['showIncidentsLayer'] as bool? ?? true,
  showTerritoriesLayer: json['showTerritoriesLayer'] as bool? ?? true,
  showCamerasLayer: json['showCamerasLayer'] as bool? ?? true,
  showResidentialDensityLayer:
      json['showResidentialDensityLayer'] as bool? ?? false,
  searchQuery: json['searchQuery'] as String? ?? '',
);

Map<String, dynamic> _$MapViewportStateToJson(_MapViewportState instance) =>
    <String, dynamic>{
      'scope': _$MapScopeEnumMap[instance.scope]!,
      'centerLat': instance.centerLat,
      'centerLng': instance.centerLng,
      'zoom': instance.zoom,
      'tilt': instance.tilt,
      'bearing': instance.bearing,
      'activeCitySlug': instance.activeCitySlug,
      'activeCityName': instance.activeCityName,
      'activeStateCode': instance.activeStateCode,
      'activeZipCode': instance.activeZipCode,
      'carFollowMode': instance.carFollowMode,
      'showIncidentsLayer': instance.showIncidentsLayer,
      'showTerritoriesLayer': instance.showTerritoriesLayer,
      'showCamerasLayer': instance.showCamerasLayer,
      'showResidentialDensityLayer': instance.showResidentialDensityLayer,
      'searchQuery': instance.searchQuery,
    };

const _$MapScopeEnumMap = {
  MapScope.area: 'area',
  MapScope.city: 'city',
  MapScope.state: 'state',
};
