// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'territory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TerritoryVertex _$TerritoryVertexFromJson(Map<String, dynamic> json) =>
    _TerritoryVertex(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$TerritoryVertexToJson(_TerritoryVertex instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

_Territory _$TerritoryFromJson(Map<String, dynamic> json) => _Territory(
  id: json['id'] as String,
  name: json['name'] as String,
  citySlug: json['citySlug'] as String,
  stateCode: json['stateCode'] as String,
  colorHex: json['colorHex'] as String,
  polygonPoints: (json['polygonPoints'] as List<dynamic>)
      .map((e) => TerritoryVertex.fromJson(e as Map<String, dynamic>))
      .toList(),
  citationDate: json['citationDate'] as String,
  sourceReference: json['sourceReference'] as String,
  contextLabel: json['contextLabel'] as String,
  historicalNotes: json['historicalNotes'] as String?,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TerritoryToJson(_Territory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'citySlug': instance.citySlug,
      'stateCode': instance.stateCode,
      'colorHex': instance.colorHex,
      'polygonPoints': instance.polygonPoints,
      'citationDate': instance.citationDate,
      'sourceReference': instance.sourceReference,
      'contextLabel': instance.contextLabel,
      'historicalNotes': instance.historicalNotes,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_TerritorySubmission _$TerritorySubmissionFromJson(Map<String, dynamic> json) =>
    _TerritorySubmission(
      id: json['id'] as String,
      territoryId: json['territoryId'] as String?,
      proposedName: json['proposedName'] as String,
      citySlug: json['citySlug'] as String,
      stateCode: json['stateCode'] as String,
      sourceCitation: json['sourceCitation'] as String,
      notes: json['notes'] as String,
      submittedByUserId: json['submittedByUserId'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      moderationStatus: json['moderationStatus'] as String? ?? 'pending_review',
    );

Map<String, dynamic> _$TerritorySubmissionToJson(
  _TerritorySubmission instance,
) => <String, dynamic>{
  'id': instance.id,
  'territoryId': instance.territoryId,
  'proposedName': instance.proposedName,
  'citySlug': instance.citySlug,
  'stateCode': instance.stateCode,
  'sourceCitation': instance.sourceCitation,
  'notes': instance.notes,
  'submittedByUserId': instance.submittedByUserId,
  'submittedAt': instance.submittedAt.toIso8601String(),
  'moderationStatus': instance.moderationStatus,
};
