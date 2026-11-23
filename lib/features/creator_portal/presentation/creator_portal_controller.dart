import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../geo_radio/domain/track_model.dart';
import '../data/creator_upload_repository.dart';
import '../domain/track_upload_request.dart';

part 'creator_portal_controller.g.dart';

/// State of the Indie Creator Portal: track uploading, errors, and published catalog.
class CreatorPortalState {
  final bool isUploading;
  final String? uploadError;
  final IndieTrack? lastUploadedTrack;
  final List<IndieTrack> publishedTracks;

  const CreatorPortalState({
    this.isUploading = false,
    this.uploadError,
    this.lastUploadedTrack,
    this.publishedTracks = const <IndieTrack>[],
  });

  CreatorPortalState copyWith({
    bool? isUploading,
    String? uploadError,
    IndieTrack? lastUploadedTrack,
    List<IndieTrack>? publishedTracks,
    bool clearError = false,
  }) {
    return CreatorPortalState(
      isUploading: isUploading ?? this.isUploading,
      uploadError: clearError ? null : (uploadError ?? this.uploadError),
      lastUploadedTrack: lastUploadedTrack ?? this.lastUploadedTrack,
      publishedTracks: publishedTracks ?? this.publishedTracks,
    );
  }
}

@Riverpod(keepAlive: true)
class CreatorPortalController extends _$CreatorPortalController {
  @override
  FutureOr<CreatorPortalState> build() async {
    final CreatorUploadRepository repository =
        ref.watch(creatorUploadRepositoryProvider);
    final List<IndieTrack> tracks = await repository.fetchArtistTracks('');
    return CreatorPortalState(publishedTracks: tracks);
  }

  /// Validates the legal rights warranty and uploads the indie track.
  Future<IndieTrack?> uploadTrack(TrackUploadRequest request) async {
    if (!request.owns100Percent) {
      state = AsyncData<CreatorPortalState>(
        state.requireValue.copyWith(
          uploadError:
              'Mandatory Warranty: You must attest that you own 100% of master '
              'recording and publishing rights.',
        ),
      );
      throw const RightsWarrantyViolationException(
        '100% rights ownership must be attested.',
      );
    }

    if (request.signedName.trim().length < 2) {
      state = AsyncData<CreatorPortalState>(
        state.requireValue.copyWith(
          uploadError:
              'Digital Signature: Please type your full legal name to execute '
              'the rights warranty.',
        ),
      );
      throw const RightsWarrantyViolationException(
        'Full electronic signature required.',
      );
    }

    state = AsyncData<CreatorPortalState>(
      state.requireValue.copyWith(
        isUploading: true,
        clearError: true,
      ),
    );

    try {
      final CreatorUploadRepository repository =
          ref.read(creatorUploadRepositoryProvider);
      final IndieTrack track = await repository.uploadTrack(request);
      final List<IndieTrack> currentList = state.requireValue.publishedTracks;
      final List<IndieTrack> updatedList = <IndieTrack>[
        track,
        ...currentList.where((IndieTrack t) => t.id != track.id),
      ];

      state = AsyncData<CreatorPortalState>(
        state.requireValue.copyWith(
          isUploading: false,
          lastUploadedTrack: track,
          publishedTracks: updatedList,
        ),
      );
      return track;
    } catch (e) {
      final String msg = e
          .toString()
          .replaceFirst('RightsWarrantyViolationException: ', '')
          .replaceFirst('Exception: ', '');
      state = AsyncData<CreatorPortalState>(
        state.requireValue.copyWith(
          isUploading: false,
          uploadError: msg,
        ),
      );
      rethrow;
    }
  }

  /// Updates local boost metadata for an active track.
  Future<void> updateTrackBoost({
    required String trackId,
    required String targetZip,
    required DateTime boostedUntil,
  }) async {
    await ref.read(creatorUploadRepositoryProvider).updateTrackBoost(
          trackId: trackId,
          targetZip: targetZip,
          boostedUntil: boostedUntil,
        );

    if (state.hasValue) {
      final List<IndieTrack> current = state.requireValue.publishedTracks;
      final List<IndieTrack> updated = current.map((IndieTrack t) {
        if (t.id == trackId) {
          return t.copyWith(
            boostTargetZip: targetZip,
            boostedUntil: boostedUntil,
          );
        }
        return t;
      }).toList();

      state = AsyncData<CreatorPortalState>(
        state.requireValue.copyWith(publishedTracks: updated),
      );
    }
  }
}
