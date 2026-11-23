import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/app_env.dart';
import '../../../core/mock/seed_data.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../domain/track_model.dart';
import '../domain/track_repository.dart';

part 'firestore_track_repository.g.dart';

/// Thrown by [FirestoreTrackRepository.publishTrack] when the mandatory
/// "I own 100% of this master recording" rights warranty is missing/invalid.
class TrackRightsViolationException implements Exception {
  const TrackRightsViolationException([
    this.message =
        'Publishing requires a signed warranty confirming you own 100% of '
        'the master recording and publishing rights.',
  ]);

  final String message;

  @override
  String toString() => 'TrackRightsViolationException: $message';
}

/// Firestore-backed [TrackRepository] with a mutable seeded local mirror.
///
/// The local mirror guarantees instant UI updates (DMCA hide, likes, boosts)
/// and is the sole data source when Firebase is unavailable / mock mode.
class FirestoreTrackRepository implements TrackRepository {
  FirestoreTrackRepository({
    FirebaseFirestore? firestore,
    DateTime Function()? clock,
    bool Function()? liveModeOverride,
    List<IndieTrack>? initialTracks,
  })  : _firestore = firestore,
        _clock = clock ?? DateTime.now,
        _liveModeOverride = liveModeOverride,
        _local = List<IndieTrack>.of(
          initialTracks ?? SeedData.buildSeedTracks(),
        );

  static const String tracksCollection = 'tracks';

  final FirebaseFirestore? _firestore;
  final DateTime Function() _clock;
  final bool Function()? _liveModeOverride;
  final List<IndieTrack> _local;
  final Set<String> _likedByMe = <String>{};

  bool get _isLive =>
      _liveModeOverride?.call() ??
      (!AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady);

  FirebaseFirestore get _db => _firestore ?? FirebaseFirestore.instance;

  /// True when [track] currently carries an active (non-expired) boost.
  static bool isBoostActive(IndieTrack track, DateTime now) {
    final until = track.boostedUntil;
    return until != null && until.isAfter(now);
  }

  /// Pure geo-aware ordering used by [fetchGeoQueue]:
  /// 1. active boosted tracks whose boost target ZIP matches [zipCode]
  /// 2. tracks matching [citySlug] (active city boosts first)
  /// 3. all other cities
  /// Ties break on `playCount` (descending). Only `status == active` tracks
  /// are ever returned, so DMCA-flagged tracks are hidden.
  static List<IndieTrack> sortGeoQueue(
    Iterable<IndieTrack> tracks, {
    required String citySlug,
    String? zipCode,
    String? genre,
    required DateTime now,
  }) {
    final wantZip = (zipCode ?? '').trim();
    final wantCity = citySlug.trim();
    final wantGenre = (genre ?? '').trim();

    int tierOf(IndieTrack t) {
      if (wantZip.isNotEmpty &&
          isBoostActive(t, now) &&
          t.boostTargetZip == wantZip) {
        return 0;
      }
      if (wantCity.isNotEmpty && t.citySlug == wantCity) return 1;
      return 2;
    }

    final filtered = tracks.where((t) {
      if (t.status != TrackStatus.active) return false;
      if (wantGenre.isNotEmpty &&
          t.genre.toLowerCase() != wantGenre.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();

    filtered.sort((a, b) {
      final tierCompare = tierOf(a).compareTo(tierOf(b));
      if (tierCompare != 0) return tierCompare;
      if (tierOf(a) == 1) {
        final boostA = isBoostActive(a, now) ? 0 : 1;
        final boostB = isBoostActive(b, now) ? 0 : 1;
        if (boostA != boostB) return boostA.compareTo(boostB);
      }
      return b.playCount.compareTo(a.playCount);
    });
    return filtered;
  }

  @override
  Future<List<IndieTrack>> fetchGeoQueue({
    required String citySlug,
    String? zipCode,
    String? genre,
    int limit = 50,
  }) async {
    var source = List<IndieTrack>.of(_local);
    if (_isLive) {
      try {
        source = await _fetchRemote(
          citySlug: citySlug,
          zipCode: zipCode,
          limit: limit,
        );
        // Overlay locally flagged tracks so a DMCA hide is instant even if
        // the remote write has not propagated yet.
        final hidden = _local
            .where((t) => t.status != TrackStatus.active)
            .map((t) => t.id)
            .toSet();
        source = source.where((t) => !hidden.contains(t.id)).toList();
      } catch (_) {
        source = List<IndieTrack>.of(_local);
      }
    }
    final sorted = sortGeoQueue(
      source,
      citySlug: citySlug,
      zipCode: zipCode,
      genre: genre,
      now: _clock(),
    );
    return sorted.take(limit).toList(growable: false);
  }

  Future<List<IndieTrack>> _fetchRemote({
    required String citySlug,
    String? zipCode,
    required int limit,
  }) async {
    final byId = <String, IndieTrack>{};
    final tracks = _db.collection(tracksCollection);

    void absorb(QuerySnapshot<Map<String, dynamic>> snap) {
      for (final doc in snap.docs) {
        final track = _trackFromFirestore(doc.id, doc.data());
        if (track != null && track.status == TrackStatus.active) {
          byId[track.id] = track;
        }
      }
    }

    if (citySlug.trim().isEmpty) {
      absorb(
        await tracks
            .where('status', isEqualTo: 'active')
            .limit(limit)
            .get(),
      );
    } else {
      absorb(
        await tracks
            .where('status', isEqualTo: 'active')
            .where('citySlug', isEqualTo: citySlug)
            .orderBy('playCount', descending: true)
            .limit(limit)
            .get(),
      );
      // Always include a bounded set from other cities for the tail tier.
      absorb(
        await tracks
            .where('status', isEqualTo: 'active')
            .limit(limit)
            .get(),
      );
    }

    final zip = (zipCode ?? '').trim();
    if (zip.isNotEmpty) {
      absorb(
        await tracks
            .where('status', isEqualTo: 'active')
            .where('boostTargetZip', isEqualTo: zip)
            .where('boostedUntil', isGreaterThan: Timestamp.fromDate(_clock()))
            .limit(limit)
            .get(),
      );
    }
    return byId.values.toList(growable: false);
  }

  @override
  Future<void> toggleLike(String trackId) async {
    final liking = _likedByMe.add(trackId);
    if (!liking) _likedByMe.remove(trackId);
    _mutateLocal(
      trackId,
      (t) => t.copyWith(
        likeCount: t.likeCount + (liking ? 1 : (t.likeCount > 0 ? -1 : 0)),
      ),
    );
    // Security rules only permit +1 increments from clients; un-likes stay
    // local to this device session.
    if (_isLive && liking) {
      await _tryRemote(
        () => _db.collection(tracksCollection).doc(trackId).update(
          <String, dynamic>{'likeCount': FieldValue.increment(1)},
        ),
      );
    }
  }

  @override
  Future<void> incrementPlayCount(String trackId) async {
    _mutateLocal(trackId, (t) => t.copyWith(playCount: t.playCount + 1));
    if (_isLive) {
      await _tryRemote(
        () => _db.collection(tracksCollection).doc(trackId).update(
          <String, dynamic>{'playCount': FieldValue.increment(1)},
        ),
      );
    }
  }

  @override
  Future<void> flagTrackDmca(String trackId) async {
    _mutateLocal(
      trackId,
      (t) => t.copyWith(status: TrackStatus.flaggedDmca),
    );
    if (_isLive) {
      await _tryRemote(
        () => _db.collection(tracksCollection).doc(trackId).update(
          <String, dynamic>{'status': 'flagged_dmca'},
        ),
      );
    }
  }

  @override
  Future<IndieTrack> publishTrack(IndieTrack track) async {
    final warranty = track.rightsWarranty;
    if (!warranty.owns100Percent || warranty.signedName.trim().isEmpty) {
      throw const TrackRightsViolationException();
    }

    _local.removeWhere((t) => t.id == track.id);
    _local.insert(0, track);

    if (_isLive) {
      final data = _trackToFirestore(track);
      await _tryRemote(
        () => _db.collection(tracksCollection).doc(track.id).set(data),
      );
    }
    return track;
  }

  @override
  Future<void> boostTrack({
    required String trackId,
    required String targetZip,
    required DateTime boostedUntil,
  }) async {
    _mutateLocal(
      trackId,
      (t) => t.copyWith(boostTargetZip: targetZip, boostedUntil: boostedUntil),
    );
    if (_isLive) {
      await _tryRemote(
        () => _db.collection(tracksCollection).doc(trackId).update(
          <String, dynamic>{
            'boostTargetZip': targetZip,
            'boostedUntil': Timestamp.fromDate(boostedUntil),
          },
        ),
      );
    }
  }

  void _mutateLocal(String trackId, IndieTrack Function(IndieTrack) update) {
    final index = _local.indexWhere((t) => t.id == trackId);
    if (index >= 0) _local[index] = update(_local[index]);
  }

  /// Remote writes are best-effort: the local mirror already reflects the
  /// change, and security rules may reject client-side mutations.
  Future<void> _tryRemote(Future<void> Function() write) async {
    try {
      await write();
    } catch (_) {}
  }

  /// Creation payload matching the backend contract: new tracks start in
  /// `processing` with zero counters and no boost fields.
  Map<String, dynamic> _trackToFirestore(IndieTrack track) {
    final json =
        jsonDecode(jsonEncode(track.toJson())) as Map<String, dynamic>;
    json
      ..['status'] = 'processing'
      ..['playCount'] = 0
      ..['likeCount'] = 0
      ..remove('boostedUntil')
      ..remove('boostTargetZip');
    final warranty = json['rightsWarranty'] as Map<String, dynamic>;
    warranty['signedAt'] = Timestamp.fromDate(track.rightsWarranty.signedAt);
    return json;
  }

  IndieTrack? _trackFromFirestore(String id, Map<String, dynamic> data) {
    try {
      final json = _normalize(data) as Map<String, dynamic>;
      json['id'] = (json['id'] as String?) ?? id;
      return IndieTrack.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  dynamic _normalize(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toUtc().toIso8601String();
    }
    if (value is Map) {
      return <String, dynamic>{
        for (final entry in value.entries)
          entry.key.toString(): _normalize(entry.value),
      };
    }
    if (value is List) {
      return value.map<dynamic>(_normalize).toList();
    }
    return value;
  }
}

@Riverpod(keepAlive: true)
TrackRepository trackRepository(Ref ref) {
  return FirestoreTrackRepository();
}
