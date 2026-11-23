// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_upload_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrackUploadRequest _$TrackUploadRequestFromJson(Map<String, dynamic> json) =>
    _TrackUploadRequest(
      artistId: json['artistId'] as String,
      artistName: json['artistName'] as String,
      title: json['title'] as String,
      genre: json['genre'] as String,
      citySlug: json['citySlug'] as String,
      cityName: json['cityName'] as String,
      stateCode: json['stateCode'] as String,
      zipCode: json['zipCode'] as String,
      audioFileName: json['audioFileName'] as String,
      audioMimeType: json['audioMimeType'] as String,
      audioSizeBytes: (json['audioSizeBytes'] as num).toInt(),
      localAudioPath: json['localAudioPath'] as String?,
      localCoverPath: json['localCoverPath'] as String?,
      owns100Percent: json['owns100Percent'] as bool,
      signedName: json['signedName'] as String,
      signedAt: DateTime.parse(json['signedAt'] as String),
      attestationVersion: json['attestationVersion'] as String,
    );

Map<String, dynamic> _$TrackUploadRequestToJson(_TrackUploadRequest instance) =>
    <String, dynamic>{
      'artistId': instance.artistId,
      'artistName': instance.artistName,
      'title': instance.title,
      'genre': instance.genre,
      'citySlug': instance.citySlug,
      'cityName': instance.cityName,
      'stateCode': instance.stateCode,
      'zipCode': instance.zipCode,
      'audioFileName': instance.audioFileName,
      'audioMimeType': instance.audioMimeType,
      'audioSizeBytes': instance.audioSizeBytes,
      'localAudioPath': instance.localAudioPath,
      'localCoverPath': instance.localCoverPath,
      'owns100Percent': instance.owns100Percent,
      'signedName': instance.signedName,
      'signedAt': instance.signedAt.toIso8601String(),
      'attestationVersion': instance.attestationVersion,
    };
