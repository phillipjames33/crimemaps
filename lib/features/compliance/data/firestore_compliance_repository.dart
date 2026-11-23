import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_env.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../domain/compliance_models.dart';
import '../domain/compliance_repository.dart';

part 'firestore_compliance_repository.g.dart';

/// Implementation of [ComplianceRepository] managing 100% free record
/// expungement requests and DMCA Safe Harbor copyright takedowns.
class FirestoreComplianceRepository implements ComplianceRepository {
  final List<MugshotRemovalRequest> _mockRemovalRequests =
      <MugshotRemovalRequest>[];
  final List<DmcaClaim> _mockDmcaClaims = <DmcaClaim>[];

  @override
  Future<MugshotRemovalRequest> submitMugshotRemoval(
    MugshotRemovalRequest request,
  ) async {
    if (!AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady) {
      try {
        final HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('submitMugshotRemoval');
        await callable.call<Map<String, dynamic>>(request.toJson());
      } catch (_) {
        // Fall back to direct Firestore write if Cloud Function is not deployed
        await FirebaseFirestore.instance
            .collection('removal_requests')
            .doc(request.id)
            .set(request.toJson());
      }
    }

    _mockRemovalRequests.add(request);
    return request;
  }

  @override
  Future<DmcaClaim> submitDmcaClaim(DmcaClaim claim) async {
    if (!AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady) {
      // 1. Record the DMCA claim
      await FirebaseFirestore.instance
          .collection('dmca_claims')
          .doc(claim.id)
          .set(claim.toJson());

      // 2. Immediately transition track status to flagged_dmca (sole allowed client update)
      try {
        await FirebaseFirestore.instance
            .collection('tracks')
            .doc(claim.trackId)
            .update(<String, dynamic>{'status': 'flagged_dmca'});
      } catch (_) {
        // Non-fatal if document does not exist in local mode
      }
    }

    _mockDmcaClaims.add(claim);
    return claim;
  }
}

@Riverpod(keepAlive: true)
ComplianceRepository complianceRepository(Ref ref) {
  return FirestoreComplianceRepository();
}
