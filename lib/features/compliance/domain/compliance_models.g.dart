// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compliance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MugshotRemovalRequest _$MugshotRemovalRequestFromJson(
  Map<String, dynamic> json,
) => _MugshotRemovalRequest(
  id: json['id'] as String,
  incidentId: json['incidentId'] as String,
  requesterName: json['requesterName'] as String,
  requesterEmail: json['requesterEmail'] as String,
  reason: $enumDecode(_$RemovalReasonEnumMap, json['reason']),
  caseNumber: json['caseNumber'] as String?,
  additionalNotes: json['additionalNotes'] as String?,
  submittedAt: DateTime.parse(json['submittedAt'] as String),
  status: json['status'] as String? ?? 'redacted_pending_verification',
);

Map<String, dynamic> _$MugshotRemovalRequestToJson(
  _MugshotRemovalRequest instance,
) => <String, dynamic>{
  'id': instance.id,
  'incidentId': instance.incidentId,
  'requesterName': instance.requesterName,
  'requesterEmail': instance.requesterEmail,
  'reason': _$RemovalReasonEnumMap[instance.reason]!,
  'caseNumber': instance.caseNumber,
  'additionalNotes': instance.additionalNotes,
  'submittedAt': instance.submittedAt.toIso8601String(),
  'status': instance.status,
};

const _$RemovalReasonEnumMap = {
  RemovalReason.expunged: 'expunged',
  RemovalReason.dismissedOrAcquitted: 'dismissedOrAcquitted',
  RemovalReason.sealedRecord: 'sealedRecord',
  RemovalReason.mistakenIdentity: 'mistakenIdentity',
  RemovalReason.privacyRequest: 'privacyRequest',
};

_DmcaClaim _$DmcaClaimFromJson(Map<String, dynamic> json) => _DmcaClaim(
  id: json['id'] as String,
  trackId: json['trackId'] as String,
  trackTitle: json['trackTitle'] as String,
  claimantName: json['claimantName'] as String,
  claimantEmail: json['claimantEmail'] as String,
  copyrightedWorkDescription: json['copyrightedWorkDescription'] as String,
  goodFaithBeliefConfirmed: json['goodFaithBeliefConfirmed'] as bool,
  perjuryStatementConfirmed: json['perjuryStatementConfirmed'] as bool,
  electronicSignature: json['electronicSignature'] as String,
  submittedAt: DateTime.parse(json['submittedAt'] as String),
  status: json['status'] as String? ?? 'track_soft_hidden',
);

Map<String, dynamic> _$DmcaClaimToJson(_DmcaClaim instance) =>
    <String, dynamic>{
      'id': instance.id,
      'trackId': instance.trackId,
      'trackTitle': instance.trackTitle,
      'claimantName': instance.claimantName,
      'claimantEmail': instance.claimantEmail,
      'copyrightedWorkDescription': instance.copyrightedWorkDescription,
      'goodFaithBeliefConfirmed': instance.goodFaithBeliefConfirmed,
      'perjuryStatementConfirmed': instance.perjuryStatementConfirmed,
      'electronicSignature': instance.electronicSignature,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'status': instance.status,
    };
