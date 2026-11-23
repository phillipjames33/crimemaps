import 'territory_model.dart';

/// Repository contract for read-only historical territory polygons and
/// moderated community submissions (never auto-published).
abstract class TerritoryRepository {
  Future<List<Territory>> fetchTerritories({
    String? citySlug,
    String? stateCode,
    int limit = 50,
  });

  /// Writes community edits strictly to `territory_submissions` for moderation.
  Future<void> submitCorrection(TerritorySubmission submission);
}
