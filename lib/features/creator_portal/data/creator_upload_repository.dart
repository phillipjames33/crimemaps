import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/config/app_env.dart';
import '../../../core/config/compliance_constants.dart';
import '../../../core/mock/seed_data.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../../geo_radio/domain/track_model.dart';
import '../domain/track_upload_request.dart';

part 'creator_upload_repository.g.dart';

/// Thrown when an audio upload violates mandatory legal rights warranties,
/// missing electronic signatures, or invalid audio format specifications.
class RightsWarrantyViolationException implements Exception {
  final String message;
  const RightsWarrantyViolationException(this.message);

  @override
  String toString() => 'RightsWarrantyViolationException: $message';
}

/// Contract for indie creator audio uploads, rights validation, and published tracks.
abstract class CreatorUploadRepository {
  Future<IndieTrack> uploadTrack(TrackUploadRequest request);
  Future<List<IndieTrack>> fetchArtistTracks(String artistId);
  Future<void> updateTrackBoost({
    required String trackId,
    required String targetZip,
    required DateTime boostedUntil,
  });
}

class CreatorUploadRepositoryImpl implements CreatorUploadRepository {
  static const Uuid _uuid = Uuid();
  final List<IndieTrack> _mockTracks = <IndieTrack>[];

  CreatorUploadRepositoryImpl() {
    _mockTracks.addAll(SeedData.buildSeedTracks());
  }

  static const Set<String> _validMimeTypes = <String>{
    'audio/mpeg',
    'audio/mp3',
    'audio/wav',
    'audio/x-wav',
    'audio/wave',
  };

  void _validateWarrantyAndFormat(TrackUploadRequest request) {
    if (!request.owns100Percent) {
      throw const RightsWarrantyViolationException(
        'Upload blocked: You must warrant and attest that you own 100% of '
        'the master recording and publishing rights to this audio.',
      );
    }

    if (request.signedName.trim().length < 2) {
      throw const RightsWarrantyViolationException(
        'Upload blocked: A valid full legal electronic signature (at least 2 '
        'characters) is required to certify copyright ownership.',
      );
    }

    final String normalizedMime = request.audioMimeType.toLowerCase().trim();
    final bool isMimeValid = _validMimeTypes.contains(normalizedMime) ||
        normalizedMime.contains('audio/mpeg') ||
        normalizedMime.contains('audio/mp3') ||
        normalizedMime.contains('audio/wav');

    final String fileName = request.audioFileName.toLowerCase().trim();
    final bool hasValidExtension =
        fileName.endsWith('.mp3') || fileName.endsWith('.wav');

    if (!isMimeValid && !hasValidExtension) {
      throw const RightsWarrantyViolationException(
        'Upload blocked: Only MP3 and WAV audio files are supported for '
        'indie geo-radio broadcasting.',
      );
    }

    if (request.audioSizeBytes <= 0 ||
        request.audioSizeBytes > ComplianceConstants.maxAudioUploadBytes) {
      throw const RightsWarrantyViolationException(
        'Upload blocked: Audio file size exceeds the maximum allowed limit of 25 MB.',
      );
    }
  }

  @override
  Future<IndieTrack> uploadTrack(TrackUploadRequest request) async {
    _validateWarrantyAndFormat(request);

    final String trackId = 'trk-${_uuid.v4().substring(0, 8)}';

    if (!AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady) {
      final String uid = FirebaseAuth.instance.currentUser?.uid ?? request.artistId;
      String audioUrl = '';
      String coverUrl = '';

      final IndieTrack initialTrack = IndieTrack(
        id: trackId,
        artistId: uid,
        artistName: request.artistName,
        title: request.title,
        genre: request.genre,
        audioUrl: '',
        coverArtUrl: '',
        durationSec: 180,
        citySlug: request.citySlug,
        cityName: request.cityName,
        stateCode: request.stateCode,
        zipCode: request.zipCode,
        rightsWarranty: RightsWarranty(
          owns100Percent: request.owns100Percent,
          signedName: request.signedName.trim(),
          signedAt: request.signedAt,
          version: request.attestationVersion,
        ),
        status: TrackStatus.processing,
        playCount: 0,
        likeCount: 0,
      );

      // Create tracks doc before uploading to Storage as per backend contract
      await FirebaseFirestore.instance
          .collection('tracks')
          .doc(trackId)
          .set(initialTrack.toJson());

      if (!kIsWeb &&
          request.localAudioPath != null &&
          request.localAudioPath!.isNotEmpty) {
        final Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('tracks/$uid/$trackId/${request.audioFileName}');

        final SettableMetadata metadata = SettableMetadata(
          contentType: request.audioMimeType,
          customMetadata: <String, String>{
            'owns100Percent': request.owns100Percent.toString(),
            'signedName': request.signedName.trim(),
            'signedAt': request.signedAt.toUtc().toIso8601String(),
            'attestationVersion': request.attestationVersion,
          },
        );

        final UploadTask uploadTask =
            storageRef.putFile(File(request.localAudioPath!), metadata);
        final TaskSnapshot snapshot = await uploadTask;
        audioUrl = await snapshot.ref.getDownloadURL();
      }

      if (!kIsWeb &&
          request.localCoverPath != null &&
          request.localCoverPath!.isNotEmpty) {
        final Reference coverRef = FirebaseStorage.instance
            .ref()
            .child('covers/$uid/$trackId/cover.jpg');
        final UploadTask coverTask =
            coverRef.putFile(File(request.localCoverPath!));
        final TaskSnapshot coverSnapshot = await coverTask;
        coverUrl = await coverSnapshot.ref.getDownloadURL();
      }

      final IndieTrack activeTrack = initialTrack.copyWith(
        audioUrl: audioUrl.isNotEmpty
            ? audioUrl
            : 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        coverArtUrl: coverUrl,
        status: TrackStatus.active,
      );

      _mockTracks.insert(0, activeTrack);
      return activeTrack;
    }

    // Local / Mock Mode
    final IndieTrack mockTrack = IndieTrack(
      id: trackId,
      artistId: request.artistId,
      artistName: request.artistName,
      title: request.title,
      genre: request.genre,
      audioUrl: request.localAudioPath ??
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      coverArtUrl: request.localCoverPath ?? '',
      durationSec: 195,
      citySlug: request.citySlug,
      cityName: request.cityName,
      stateCode: request.stateCode,
      zipCode: request.zipCode,
      rightsWarranty: RightsWarranty(
        owns100Percent: request.owns100Percent,
        signedName: request.signedName.trim(),
        signedAt: request.signedAt,
        version: request.attestationVersion,
      ),
      status: TrackStatus.active,
      playCount: 0,
      likeCount: 0,
    );

    _mockTracks.insert(0, mockTrack);
    return mockTrack;
  }

  @override
  Future<List<IndieTrack>> fetchArtistTracks(String artistId) async {
    if (!AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady) {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('tracks')
              .where('artistId', isEqualTo: artistId)
              .get();

      return snapshot.docs
          .map((doc) => IndieTrack.fromJson(doc.data()))
          .toList();
    }

    if (artistId.isEmpty) {
      return List<IndieTrack>.unmodifiable(_mockTracks);
    }
    return _mockTracks
        .where((track) => track.artistId == artistId || track.artistId.contains('artist-'))
        .toList();
  }

  @override
  Future<void> updateTrackBoost({
    required String trackId,
    required String targetZip,
    required DateTime boostedUntil,
  }) async {
    if (!AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady) {
      await FirebaseFirestore.instance.collection('tracks').doc(trackId).update(
        <String, dynamic>{
          'boostTargetZip': targetZip,
          'boostedUntil': boostedUntil.toUtc().toIso8601String(),
        },
      );
    }

    final int index = _mockTracks.indexWhere((t) => t.id == trackId);
    if (index != -1) {
      final IndieTrack current = _mockTracks[index];
      _mockTracks[index] = current.copyWith(
        boostTargetZip: targetZip,
        boostedUntil: boostedUntil,
      );
    }
  }
}

@Riverpod(keepAlive: true)
CreatorUploadRepository creatorUploadRepository(Ref ref) {
  return CreatorUploadRepositoryImpl();
}
