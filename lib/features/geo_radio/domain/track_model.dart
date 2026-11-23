import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_model.freezed.dart';
part 'track_model.g.dart';

enum TrackStatus {
  @JsonValue('active')
  active,
  @JsonValue('flagged_dmca')
  flaggedDmca,
  @JsonValue('processing')
  processing,
}

@freezed
abstract class RightsWarranty with _$RightsWarranty {
  const factory RightsWarranty({
    required bool owns100Percent,
    required String signedName,
    required DateTime signedAt,
    required String version,
  }) = _RightsWarranty;

  factory RightsWarranty.fromJson(Map<String, dynamic> json) =>
      _$RightsWarrantyFromJson(json);
}

@freezed
abstract class IndieTrack with _$IndieTrack {
  const factory IndieTrack({
    required String id,
    required String artistId,
    required String artistName,
    required String title,
    required String genre,
    required String audioUrl,
    required String coverArtUrl,
    required int durationSec,
    required String citySlug,
    required String cityName,
    required String stateCode,
    required String zipCode,
    DateTime? boostedUntil,
    String? boostTargetZip,
    required RightsWarranty rightsWarranty,
    @Default(TrackStatus.active) TrackStatus status,
    @Default(0) int playCount,
    @Default(0) int likeCount,
  }) = _IndieTrack;

  factory IndieTrack.fromJson(Map<String, dynamic> json) =>
      _$IndieTrackFromJson(json);
}
