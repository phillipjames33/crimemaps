// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GeoCoordinate _$GeoCoordinateFromJson(Map<String, dynamic> json) =>
    _GeoCoordinate(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      geohash: json['geohash'] as String,
    );

Map<String, dynamic> _$GeoCoordinateToJson(_GeoCoordinate instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'geohash': instance.geohash,
    };

_AllegedOffender _$AllegedOffenderFromJson(Map<String, dynamic> json) =>
    _AllegedOffender(
      name: json['name'] as String,
      bookingPhotoUrl: json['bookingPhotoUrl'] as String?,
      charges: (json['charges'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      sourceAgency: json['sourceAgency'] as String,
      disclaimer: json['disclaimer'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      redacted: json['redacted'] as bool? ?? false,
    );

Map<String, dynamic> _$AllegedOffenderToJson(_AllegedOffender instance) =>
    <String, dynamic>{
      'name': instance.name,
      'bookingPhotoUrl': instance.bookingPhotoUrl,
      'charges': instance.charges,
      'bookingDate': instance.bookingDate.toIso8601String(),
      'sourceAgency': instance.sourceAgency,
      'disclaimer': instance.disclaimer,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'redacted': instance.redacted,
    };

_Incident _$IncidentFromJson(Map<String, dynamic> json) => _Incident(
  id: json['id'] as String,
  title: json['title'] as String,
  category: $enumDecode(_$IncidentCategoryEnumMap, json['category']),
  severity: $enumDecode(_$IncidentSeverityEnumMap, json['severity']),
  address: json['address'] as String,
  placeName: json['placeName'] as String,
  placeType: json['placeType'] as String,
  geo: GeoCoordinate.fromJson(json['geo'] as Map<String, dynamic>),
  citySlug: json['citySlug'] as String,
  cityName: json['cityName'] as String,
  stateCode: json['stateCode'] as String,
  occurredAt: DateTime.parse(json['occurredAt'] as String),
  streetViewUrl: json['streetViewUrl'] as String?,
  sourceAgency: json['sourceAgency'] as String,
  allegedOffender: json['allegedOffender'] == null
      ? null
      : AllegedOffender.fromJson(
          json['allegedOffender'] as Map<String, dynamic>,
        ),
  expireAt: json['expireAt'] == null
      ? null
      : DateTime.parse(json['expireAt'] as String),
);

Map<String, dynamic> _$IncidentToJson(_Incident instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'category': _$IncidentCategoryEnumMap[instance.category]!,
  'severity': _$IncidentSeverityEnumMap[instance.severity]!,
  'address': instance.address,
  'placeName': instance.placeName,
  'placeType': instance.placeType,
  'geo': instance.geo,
  'citySlug': instance.citySlug,
  'cityName': instance.cityName,
  'stateCode': instance.stateCode,
  'occurredAt': instance.occurredAt.toIso8601String(),
  'streetViewUrl': instance.streetViewUrl,
  'sourceAgency': instance.sourceAgency,
  'allegedOffender': instance.allegedOffender,
  'expireAt': instance.expireAt?.toIso8601String(),
};

const _$IncidentCategoryEnumMap = {
  IncidentCategory.violent: 'violent',
  IncidentCategory.property: 'property',
  IncidentCategory.trafficDui: 'trafficDui',
  IncidentCategory.other: 'other',
};

const _$IncidentSeverityEnumMap = {
  IncidentSeverity.low: 'low',
  IncidentSeverity.medium: 'medium',
  IncidentSeverity.high: 'high',
  IncidentSeverity.critical: 'critical',
};
