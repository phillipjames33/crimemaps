import 'package:freezed_annotation/freezed_annotation.dart';

part 'territory_model.freezed.dart';
part 'territory_model.g.dart';

@freezed
abstract class TerritoryVertex with _$TerritoryVertex {
  const factory TerritoryVertex({
    required double latitude,
    required double longitude,
  }) = _TerritoryVertex;

  factory TerritoryVertex.fromJson(Map<String, dynamic> json) =>
      _$TerritoryVertexFromJson(json);
}

@freezed
abstract class Territory with _$Territory {
  const factory Territory({
    required String id,
    required String name,
    required String citySlug,
    required String stateCode,
    required String colorHex,
    required List<TerritoryVertex> polygonPoints,
    required String citationDate,
    required String sourceReference,
    required String contextLabel,
    String? historicalNotes,
    required DateTime updatedAt,
  }) = _Territory;

  factory Territory.fromJson(Map<String, dynamic> json) =>
      _$TerritoryFromJson(json);
}

@freezed
abstract class TerritorySubmission with _$TerritorySubmission {
  const factory TerritorySubmission({
    required String id,
    String? territoryId,
    required String proposedName,
    required String citySlug,
    required String stateCode,
    required String sourceCitation,
    required String notes,
    required String submittedByUserId,
    required DateTime submittedAt,
    @Default('pending_review') String moderationStatus,
  }) = _TerritorySubmission;

  factory TerritorySubmission.fromJson(Map<String, dynamic> json) =>
      _$TerritorySubmissionFromJson(json);
}
