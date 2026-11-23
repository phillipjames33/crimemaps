import 'package:freezed_annotation/freezed_annotation.dart';

part 'compliance_models.freezed.dart';
part 'compliance_models.g.dart';

enum RemovalReason {
  expunged,
  dismissedOrAcquitted,
  sealedRecord,
  mistakenIdentity,
  privacyRequest,
}

@freezed
abstract class MugshotRemovalRequest with _$MugshotRemovalRequest {
  const factory MugshotRemovalRequest({
    required String id,
    required String incidentId,
    required String requesterName,
    required String requesterEmail,
    required RemovalReason reason,
    String? caseNumber,
    String? additionalNotes,
    required DateTime submittedAt,
    @Default('redacted_pending_verification') String status,
  }) = _MugshotRemovalRequest;

  factory MugshotRemovalRequest.fromJson(Map<String, dynamic> json) =>
      _$MugshotRemovalRequestFromJson(json);
}

@freezed
abstract class DmcaClaim with _$DmcaClaim {
  const factory DmcaClaim({
    required String id,
    required String trackId,
    required String trackTitle,
    required String claimantName,
    required String claimantEmail,
    required String copyrightedWorkDescription,
    required bool goodFaithBeliefConfirmed,
    required bool perjuryStatementConfirmed,
    required String electronicSignature,
    required DateTime submittedAt,
    @Default('track_soft_hidden') String status,
  }) = _DmcaClaim;

  factory DmcaClaim.fromJson(Map<String, dynamic> json) =>
      _$DmcaClaimFromJson(json);
}
