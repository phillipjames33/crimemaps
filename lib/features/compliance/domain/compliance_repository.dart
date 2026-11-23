import 'compliance_models.dart';

/// Repository contract for mandatory legal compliance workflows:
/// 1) 100% free mugshot/record removal & expungement
/// 2) Instant DMCA Safe Harbor copyright takedown
abstract class ComplianceRepository {
  /// Submits a 100% free removal request and immediately redacts the
  /// alleged offender fields pending verification.
  Future<MugshotRemovalRequest> submitMugshotRemoval(
    MugshotRemovalRequest request,
  );

  /// Submits a DMCA copyright infringement claim and immediately transitions
  /// the target track status to `flagged_dmca`.
  Future<DmcaClaim> submitDmcaClaim(DmcaClaim claim);
}
