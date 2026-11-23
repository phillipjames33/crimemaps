import 'track_model.dart';

/// Repository contract for geo-aware independent music discovery and DMCA hiding.
abstract class TrackRepository {
  /// Returns active indie tracks prioritizing boosted & city-matched tracks first.
  Future<List<IndieTrack>> fetchGeoQueue({
    required String citySlug,
    String? zipCode,
    String? genre,
    int limit = 50,
  });

  Future<void> toggleLike(String trackId);

  Future<void> incrementPlayCount(String trackId);

  /// Immediately marks a track as `flagged_dmca` so it disappears from public queries.
  Future<void> flagTrackDmca(String trackId);

  /// Adds a newly uploaded creator track (requires verified 100% ownership warranty).
  Future<IndieTrack> publishTrack(IndieTrack track);

  /// Applies a geo-targeted boost for a city/ZIP code.
  Future<void> boostTrack({
    required String trackId,
    required String targetZip,
    required DateTime boostedUntil,
  });
}
