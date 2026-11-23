import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/mock/seed_data.dart';
import '../data/audio_player_service.dart';
import '../data/firestore_track_repository.dart';
import '../domain/track_model.dart';
import '../domain/track_repository.dart';

part 'geo_radio_controller.g.dart';

/// City selector option for the Geo-Radio discovery tab.
class GeoRadioCity {
  const GeoRadioCity({required this.slug, required this.label, this.zipCode});

  /// `null` slug means "All Cities".
  final String? slug;
  final String label;
  final String? zipCode;

  static const GeoRadioCity atlanta = GeoRadioCity(
    slug: 'atlanta',
    label: 'Atlanta',
    zipCode: '30308',
  );
  static const GeoRadioCity savannah = GeoRadioCity(
    slug: 'savannah',
    label: 'Savannah',
    zipCode: '31401',
  );
  static const GeoRadioCity chicago = GeoRadioCity(
    slug: 'chicago',
    label: 'Chicago',
    zipCode: '60601',
  );
  static const GeoRadioCity all = GeoRadioCity(slug: null, label: 'All Cities');

  static const List<GeoRadioCity> options = <GeoRadioCity>[
    atlanta,
    savannah,
    chicago,
    all,
  ];
}

/// Genre filter chips (first entry, `null`, means all genres).
const List<String> kGeoRadioGenres = <String>[
  'Southern Hip-Hop',
  'Alt R&B',
  'Trap Soul',
  'Lo-Fi Beats',
  'House / Electronic',
];

/// True while [track] has a non-expired boost.
bool isTrackBoosted(IndieTrack track, [DateTime? now]) {
  final until = track.boostedUntil;
  return until != null && until.isAfter(now ?? DateTime.now());
}

/// Immutable state of the Geo-Radio queue and player.
class GeoRadioState {
  const GeoRadioState({
    this.queue = const <IndieTrack>[],
    this.activeCitySlug,
    this.zipCode,
    this.genre,
    this.currentTrack,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.likedTrackIds = const <String>{},
    this.isLoading = false,
  });

  final List<IndieTrack> queue;

  /// `null` means "All Cities".
  final String? activeCitySlug;
  final String? zipCode;
  final String? genre;
  final IndieTrack? currentTrack;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final Set<String> likedTrackIds;
  final bool isLoading;

  GeoRadioState copyWith({
    List<IndieTrack>? queue,
    String? activeCitySlug,
    bool clearCity = false,
    String? zipCode,
    bool clearZip = false,
    String? genre,
    bool clearGenre = false,
    IndieTrack? currentTrack,
    bool clearCurrentTrack = false,
    Duration? position,
    Duration? duration,
    bool? isPlaying,
    Set<String>? likedTrackIds,
    bool? isLoading,
  }) {
    return GeoRadioState(
      queue: queue ?? this.queue,
      activeCitySlug: clearCity ? null : (activeCitySlug ?? this.activeCitySlug),
      zipCode: clearZip ? null : (zipCode ?? this.zipCode),
      genre: clearGenre ? null : (genre ?? this.genre),
      currentTrack:
          clearCurrentTrack ? null : (currentTrack ?? this.currentTrack),
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isPlaying: isPlaying ?? this.isPlaying,
      likedTrackIds: likedTrackIds ?? this.likedTrackIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@Riverpod(keepAlive: true)
class GeoRadioController extends _$GeoRadioController {
  int _queueRequestId = 0;
  bool _disposed = false;

  TrackRepository get _repository => ref.read(trackRepositoryProvider);
  AudioPlayerService get _audio => ref.read(audioPlayerServiceProvider);

  @override
  GeoRadioState build() {
    _disposed = false;
    final audio = ref.read(audioPlayerServiceProvider);

    final subscriptions = <StreamSubscription<dynamic>>[
      audio.positionStream.listen((position) {
        if (_disposed) return;
        state = state.copyWith(position: position);
      }),
      audio.durationStream.listen((duration) {
        if (_disposed || duration == null) return;
        state = state.copyWith(duration: duration);
      }),
      audio.playingStream.listen((playing) {
        if (_disposed) return;
        state = state.copyWith(isPlaying: playing);
      }),
      audio.completedStream.listen((_) => unawaited(next())),
      audio.skipNextStream.listen((_) => unawaited(next())),
      audio.skipPreviousStream.listen((_) => unawaited(previous())),
    ];

    ref.onDispose(() {
      _disposed = true;
      for (final sub in subscriptions) {
        unawaited(sub.cancel());
      }
    });

    unawaited(Future<void>.microtask(refreshQueue));

    final initialQueue = FirestoreTrackRepository.sortGeoQueue(
      SeedData.buildSeedTracks(),
      citySlug: 'atlanta',
      zipCode: '30308',
      now: DateTime.now(),
    );
    final initialTrack = initialQueue.isNotEmpty ? initialQueue.first : null;

    return GeoRadioState(
      queue: initialQueue,
      activeCitySlug: 'atlanta',
      zipCode: '30308',
      currentTrack: initialTrack,
      duration: initialTrack != null
          ? Duration(seconds: initialTrack.durationSec)
          : Duration.zero,
    );
  }

  /// Reloads the geo-aware queue for the current city / ZIP / genre filters.
  Future<void> refreshQueue() async {
    if (_disposed) return;
    final requestId = ++_queueRequestId;
    state = state.copyWith(isLoading: true);
    try {
      final fetched = await _repository.fetchGeoQueue(
        citySlug: state.activeCitySlug ?? '',
        zipCode: state.zipCode,
        genre: state.genre,
      );
      if (_disposed || requestId != _queueRequestId) return;
      final activeQueue = fetched
          .where((t) => t.status == TrackStatus.active)
          .toList(growable: false);
      final current = state.currentTrack;
      final keepCurrent =
          state.isPlaying &&
          current != null &&
          activeQueue.any((t) => t.id == current.id);
      final nextCurrent = keepCurrent
          ? activeQueue.firstWhere((t) => t.id == current.id)
          : (activeQueue.isNotEmpty ? activeQueue.first : null);
      state = state.copyWith(
        queue: activeQueue,
        currentTrack: nextCurrent,
        clearCurrentTrack: nextCurrent == null,
        duration: nextCurrent != null && !keepCurrent
            ? Duration(seconds: nextCurrent.durationSec)
            : state.duration,
        isLoading: false,
      );
    } catch (_) {
      if (_disposed || requestId != _queueRequestId) return;
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setCity(GeoRadioCity city) async {
    state = city.slug == null
        ? state.copyWith(clearCity: true, clearZip: true)
        : state.copyWith(
            activeCitySlug: city.slug,
            zipCode: city.zipCode,
            clearZip: city.zipCode == null,
          );
    await refreshQueue();
  }

  Future<void> setZipCode(String? zip) async {
    final trimmed = zip?.trim() ?? '';
    state = trimmed.isEmpty
        ? state.copyWith(clearZip: true)
        : state.copyWith(zipCode: trimmed);
    await refreshQueue();
  }

  Future<void> setGenre(String? genre) async {
    state = (genre == null || genre.isEmpty)
        ? state.copyWith(clearGenre: true)
        : state.copyWith(genre: genre);
    await refreshQueue();
  }

  Future<void> playTrack(IndieTrack track) async {
    state = state.copyWith(
      currentTrack: track,
      position: Duration.zero,
      duration: Duration(seconds: track.durationSec),
      isPlaying: true,
    );
    await _audio.playTrack(track);
    unawaited(_repository.incrementPlayCount(track.id));
  }

  Future<void> togglePlayPause() async {
    final current = state.currentTrack;
    if (current == null) {
      if (state.queue.isNotEmpty) await playTrack(state.queue.first);
      return;
    }
    if (state.isPlaying) {
      state = state.copyWith(isPlaying: false);
      await _audio.pause();
    } else {
      state = state.copyWith(isPlaying: true);
      await _audio.resume();
    }
  }

  Future<void> next() async {
    final queue = state.queue;
    if (queue.isEmpty) return;
    final current = state.currentTrack;
    final index = current == null
        ? -1
        : queue.indexWhere((t) => t.id == current.id);
    await playTrack(queue[(index + 1) % queue.length]);
  }

  Future<void> previous() async {
    final queue = state.queue;
    if (queue.isEmpty) return;
    if (state.position > const Duration(seconds: 3)) {
      await seek(Duration.zero);
      return;
    }
    final current = state.currentTrack;
    final index = current == null
        ? 0
        : queue.indexWhere((t) => t.id == current.id);
    final prev = index <= 0 ? queue.length - 1 : index - 1;
    await playTrack(queue[prev]);
  }

  Future<void> seek(Duration position) async {
    state = state.copyWith(position: position);
    await _audio.seek(position);
  }

  Future<void> toggleLike(String trackId) async {
    final liked = Set<String>.of(state.likedTrackIds);
    if (!liked.add(trackId)) liked.remove(trackId);
    state = state.copyWith(likedTrackIds: liked);
    await _repository.toggleLike(trackId);
    await refreshQueue();
  }

  /// Publishes a newly uploaded track into the geo queue. Returns `false`
  /// (and adds nothing) if the 100% ownership warranty is invalid.
  Future<bool> addPublishedTrack(IndieTrack track) async {
    try {
      await _repository.publishTrack(track);
    } on TrackRightsViolationException {
      return false;
    }
    await refreshQueue();
    return true;
  }

  /// Applies an artist boost and re-sorts the queue.
  Future<void> applyBoost({
    required String trackId,
    required String targetZip,
    required DateTime boostedUntil,
  }) async {
    await _repository.boostTrack(
      trackId: trackId,
      targetZip: targetZip,
      boostedUntil: boostedUntil,
    );
    await refreshQueue();
  }

  /// Flags a track for DMCA and instantly hides it from the queue.
  Future<void> flagDmca(String trackId) async {
    // Optimistic instant hide.
    final remaining = state.queue.where((t) => t.id != trackId).toList();
    final wasCurrent = state.currentTrack?.id == trackId;
    state = wasCurrent
        ? state.copyWith(
            queue: remaining,
            clearCurrentTrack: true,
            isPlaying: false,
            position: Duration.zero,
          )
        : state.copyWith(queue: remaining);
    if (wasCurrent) await _audio.stop();
    await _repository.flagTrackDmca(trackId);
    await refreshQueue();
  }

  /// Alias used by UI callers that only have a track id.
  Future<void> flagTrackDmca(String trackId) => flagDmca(trackId);
}
