// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RightsWarranty _$RightsWarrantyFromJson(Map<String, dynamic> json) =>
    _RightsWarranty(
      owns100Percent: json['owns100Percent'] as bool,
      signedName: json['signedName'] as String,
      signedAt: DateTime.parse(json['signedAt'] as String),
      version: json['version'] as String,
    );

Map<String, dynamic> _$RightsWarrantyToJson(_RightsWarranty instance) =>
    <String, dynamic>{
      'owns100Percent': instance.owns100Percent,
      'signedName': instance.signedName,
      'signedAt': instance.signedAt.toIso8601String(),
      'version': instance.version,
    };

_IndieTrack _$IndieTrackFromJson(Map<String, dynamic> json) => _IndieTrack(
  id: json['id'] as String,
  artistId: json['artistId'] as String,
  artistName: json['artistName'] as String,
  title: json['title'] as String,
  genre: json['genre'] as String,
  audioUrl: json['audioUrl'] as String,
  coverArtUrl: json['coverArtUrl'] as String,
  durationSec: (json['durationSec'] as num).toInt(),
  citySlug: json['citySlug'] as String,
  cityName: json['cityName'] as String,
  stateCode: json['stateCode'] as String,
  zipCode: json['zipCode'] as String,
  boostedUntil: json['boostedUntil'] == null
      ? null
      : DateTime.parse(json['boostedUntil'] as String),
  boostTargetZip: json['boostTargetZip'] as String?,
  rightsWarranty: RightsWarranty.fromJson(
    json['rightsWarranty'] as Map<String, dynamic>,
  ),
  status:
      $enumDecodeNullable(_$TrackStatusEnumMap, json['status']) ??
      TrackStatus.active,
  playCount: (json['playCount'] as num?)?.toInt() ?? 0,
  likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$IndieTrackToJson(_IndieTrack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'artistId': instance.artistId,
      'artistName': instance.artistName,
      'title': instance.title,
      'genre': instance.genre,
      'audioUrl': instance.audioUrl,
      'coverArtUrl': instance.coverArtUrl,
      'durationSec': instance.durationSec,
      'citySlug': instance.citySlug,
      'cityName': instance.cityName,
      'stateCode': instance.stateCode,
      'zipCode': instance.zipCode,
      'boostedUntil': instance.boostedUntil?.toIso8601String(),
      'boostTargetZip': instance.boostTargetZip,
      'rightsWarranty': instance.rightsWarranty,
      'status': _$TrackStatusEnumMap[instance.status]!,
      'playCount': instance.playCount,
      'likeCount': instance.likeCount,
    };

const _$TrackStatusEnumMap = {
  TrackStatus.active: 'active',
  TrackStatus.flaggedDmca: 'flagged_dmca',
  TrackStatus.processing: 'processing',
};
