import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_model.freezed.dart';
part 'camera_model.g.dart';

/// Public civic infrastructure camera types ONLY.
/// Private residential doorbells are strictly excluded from exact pinning.
enum PublicCameraType {
  @JsonValue('alpr_flock')
  alprFlock,
  @JsonValue('traffic')
  traffic,
  @JsonValue('red_light')
  redLight,
}

enum CameraSource {
  @JsonValue('osm_deflock')
  osmDeflock,
  @JsonValue('community')
  community,
}

@freezed
abstract class PublicCamera with _$PublicCamera {
  const factory PublicCamera({
    required String id,
    required PublicCameraType type,
    required String operatorName,
    required double latitude,
    required double longitude,
    required String geohash,
    double? directionHeading,
    @Default(true) bool verified,
    required CameraSource source,
    required String citySlug,
    required String stateCode,
    required DateTime updatedAt,
  }) = _PublicCamera;

  factory PublicCamera.fromJson(Map<String, dynamic> json) =>
      _$PublicCameraFromJson(json);
}

/// Anonymized neighborhood-level residential density cell (never exact house pins).
@freezed
abstract class ResidentialDensityCell with _$ResidentialDensityCell {
  const factory ResidentialDensityCell({
    required String geohashCell,
    required double centerLat,
    required double centerLng,
    required double radiusMeters,
    required double normalizedDensity,
    required String neighborhoodName,
  }) = _ResidentialDensityCell;

  factory ResidentialDensityCell.fromJson(Map<String, dynamic> json) =>
      _$ResidentialDensityCellFromJson(json);
}

@freezed
abstract class CameraAlertSettings with _$CameraAlertSettings {
  const factory CameraAlertSettings({
    @Default(true) bool enabled,
    @Default(true) bool audioChime,
    @Default(250.0) double radiusMeters,
    @Default(false) bool showResidentialDensityHeatmap,
  }) = _CameraAlertSettings;

  factory CameraAlertSettings.fromJson(Map<String, dynamic> json) =>
      _$CameraAlertSettingsFromJson(json);
}

@freezed
abstract class CameraProximityAlert with _$CameraProximityAlert {
  const factory CameraProximityAlert({
    required PublicCamera camera,
    required double distanceMeters,
    required DateTime triggeredAt,
  }) = _CameraProximityAlert;

  factory CameraProximityAlert.fromJson(Map<String, dynamic> json) =>
      _$CameraProximityAlertFromJson(json);
}

/// Validation result for community public camera reporting (enforces anti-doxxing).
@freezed
abstract class CameraSubmissionRequest with _$CameraSubmissionRequest {
  const factory CameraSubmissionRequest({
    required PublicCameraType type,
    required String operatorName,
    required double latitude,
    required double longitude,
    required String citySlug,
    required String stateCode,
    required bool isPrivateResidence,
    String? streetNotes,
  }) = _CameraSubmissionRequest;

  factory CameraSubmissionRequest.fromJson(Map<String, dynamic> json) =>
      _$CameraSubmissionRequestFromJson(json);
}
