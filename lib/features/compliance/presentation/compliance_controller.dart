import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/firestore_compliance_repository.dart';
import '../domain/compliance_models.dart';
import '../domain/compliance_repository.dart';

part 'compliance_controller.g.dart';

@Riverpod(keepAlive: true)
class ComplianceController extends _$ComplianceController {
  @override
  FutureOr<void> build() {
    // Initial idle state
  }

  /// Submits a 100% free mugshot/record expungement request.
  Future<MugshotRemovalRequest> submitMugshotRemoval(
    MugshotRemovalRequest request,
  ) async {
    state = const AsyncLoading<void>();
    final ComplianceRepository repo = ref.read(complianceRepositoryProvider);
    try {
      final MugshotRemovalRequest result =
          await repo.submitMugshotRemoval(request);
      state = const AsyncData<void>(null);
      return result;
    } catch (e, st) {
      state = AsyncError<void>(e, st);
      rethrow;
    }
  }

  /// Submits a DMCA copyright takedown claim and triggers soft-hiding of the track.
  Future<DmcaClaim> submitDmcaClaim(DmcaClaim claim) async {
    state = const AsyncLoading<void>();
    final ComplianceRepository repo = ref.read(complianceRepositoryProvider);
    try {
      final DmcaClaim result = await repo.submitDmcaClaim(claim);
      state = const AsyncData<void>(null);
      return result;
    } catch (e, st) {
      state = AsyncError<void>(e, st);
      rethrow;
    }
  }
}
