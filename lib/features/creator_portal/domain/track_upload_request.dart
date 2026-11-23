import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_upload_request.freezed.dart';
part 'track_upload_request.g.dart';

@freezed
abstract class TrackUploadRequest with _$TrackUploadRequest {
  const factory TrackUploadRequest({
    required String artistId,
    required String artistName,
    required String title,
    required String genre,
    required String citySlug,
    required String cityName,
    required String stateCode,
    required String zipCode,
    required String audioFileName,
    required String audioMimeType,
    required int audioSizeBytes,
    String? localAudioPath,
    String? localCoverPath,
    required bool owns100Percent,
    required String signedName,
    required DateTime signedAt,
    required String attestationVersion,
  }) = _TrackUploadRequest;

  factory TrackUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$TrackUploadRequestFromJson(json);
}
