import 'camera_model.dart';

/// Repository contract for syncing public ALPR/traffic cameras by geohash cell
/// into local cache and validating anti-doxxing community reports.
abstract class CameraRepository {
  /// Fetches cameras for a geohash cell (with explicit limit) to populate
  /// the local spatial cache. Never called on every GPS tick.
  Future<List<PublicCamera>> syncCamerasForGeohashCell({
    required String cellPrefix,
    required double centerLat,
    required double centerLng,
    int limit = 150,
  });

  /// Returns anonymized neighborhood-level residential camera density zones.
  Future<List<ResidentialDensityCell>> fetchResidentialDensityCells({
    String? citySlug,
  });

  /// Submits a public-facing infrastructure camera. MUST reject any
  /// `isPrivateResidence == true` submission (anti-doxxing guardrail).
  Future<void> submitPublicCamera(CameraSubmissionRequest request);
}
