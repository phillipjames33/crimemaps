// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublicCamera _$PublicCameraFromJson(Map<String, dynamic> json) =>
    _PublicCamera(
      id: json['id'] as String,
      type: $enumDecode(_$PublicCameraTypeEnumMap, json['type']),
      operatorName: json['operatorName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      geohash: json['geohash'] as String,
      directionHeading: (json['directionHeading'] as num?)?.toDouble(),
      verified: json['verified'] as bool? ?? true,
      source: $enumDecode(_$CameraSourceEnumMap, json['source']),
      citySlug: json['citySlug'] as String,
      stateCode: json['stateCode'] as String,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$PublicCameraToJson(_PublicCamera instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PublicCameraTypeEnumMap[instance.type]!,
      'operatorName': instance.operatorName,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'geohash': instance.geohash,
      'directionHeading': instance.directionHeading,
      'verified': instance.verified,
      'source': _$CameraSourceEnumMap[instance.source]!,
      'citySlug': instance.citySlug,
      'stateCode': instance.stateCode,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$PublicCameraTypeEnumMap = {
  PublicCameraType.alprFlock: 'alpr_flock',
  PublicCameraType.traffic: 'traffic',
  PublicCameraType.redLight: 'red_light',
};

const _$CameraSourceEnumMap = {
  CameraSource.osmDeflock: 'osm_deflock',
  CameraSource.community: 'community',
};

_ResidentialDensityCell _$ResidentialDensityCellFromJson(
  Map<String, dynamic> json,
) => _ResidentialDensityCell(
  geohashCell: json['geohashCell'] as String,
  centerLat: (json['centerLat'] as num).toDouble(),
  centerLng: (json['centerLng'] as num).toDouble(),
  radiusMeters: (json['radiusMeters'] as num).toDouble(),
  normalizedDensity: (json['normalizedDensity'] as num).toDouble(),
  neighborhoodName: json['neighborhoodName'] as String,
);

Map<String, dynamic> _$ResidentialDensityCellToJson(
  _ResidentialDensityCell instance,
) => <String, dynamic>{
  'geohashCell': instance.geohashCell,
  'centerLat': instance.centerLat,
  'centerLng': instance.centerLng,
  'radiusMeters': instance.radiusMeters,
  'normalizedDensity': instance.normalizedDensity,
  'neighborhoodName': instance.neighborhoodName,
};

_CameraAlertSettings _$CameraAlertSettingsFromJson(Map<String, dynamic> json) =>
    _CameraAlertSettings(
      enabled: json['enabled'] as bool? ?? true,
      audioChime: json['audioChime'] as bool? ?? true,
      radiusMeters: (json['radiusMeters'] as num?)?.toDouble() ?? 250.0,
      showResidentialDensityHeatmap:
          json['showResidentialDensityHeatmap'] as bool? ?? false,
    );

Map<String, dynamic> _$CameraAlertSettingsToJson(
  _CameraAlertSettings instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'audioChime': instance.audioChime,
  'radiusMeters': instance.radiusMeters,
  'showResidentialDensityHeatmap': instance.showResidentialDensityHeatmap,
};

_CameraProximityAlert _$CameraProximityAlertFromJson(
  Map<String, dynamic> json,
) => _CameraProximityAlert(
  camera: PublicCamera.fromJson(json['camera'] as Map<String, dynamic>),
  distanceMeters: (json['distanceMeters'] as num).toDouble(),
  triggeredAt: DateTime.parse(json['triggeredAt'] as String),
);

Map<String, dynamic> _$CameraProximityAlertToJson(
  _CameraProximityAlert instance,
) => <String, dynamic>{
  'camera': instance.camera,
  'distanceMeters': instance.distanceMeters,
  'triggeredAt': instance.triggeredAt.toIso8601String(),
};

_CameraSubmissionRequest _$CameraSubmissionRequestFromJson(
  Map<String, dynamic> json,
) => _CameraSubmissionRequest(
  type: $enumDecode(_$PublicCameraTypeEnumMap, json['type']),
  operatorName: json['operatorName'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  citySlug: json['citySlug'] as String,
  stateCode: json['stateCode'] as String,
  isPrivateResidence: json['isPrivateResidence'] as bool,
  streetNotes: json['streetNotes'] as String?,
);

Map<String, dynamic> _$CameraSubmissionRequestToJson(
  _CameraSubmissionRequest instance,
) => <String, dynamic>{
  'type': _$PublicCameraTypeEnumMap[instance.type]!,
  'operatorName': instance.operatorName,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'citySlug': instance.citySlug,
  'stateCode': instance.stateCode,
  'isPrivateResidence': instance.isPrivateResidence,
  'streetNotes': instance.streetNotes,
};
