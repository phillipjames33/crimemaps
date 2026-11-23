import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/track_model.dart';

part 'audio_player_service.g.dart';

/// `audio_service` handler that exposes the shared `just_audio` player to
/// lock-screen / notification controls with background playback metadata.
class CrimeMapsAudioHandler extends BaseAudioHandler with SeekHandler {
  CrimeMapsAudioHandler(
    this._player, {
    this.onSkipNext,
    this.onSkipPrevious,
  }) {
    _eventSub = _player.playbackEventStream.listen(
      _broadcastState,
      onError: (Object error, StackTrace stackTrace) {},
    );
  }

  final AudioPlayer _player;
  final void Function()? onSkipNext;
  final void Function()? onSkipPrevious;
  StreamSubscription<PlaybackEvent>? _eventSub;

  static const Map<ProcessingState, AudioProcessingState> _processingMap =
      <ProcessingState, AudioProcessingState>{
    ProcessingState.idle: AudioProcessingState.idle,
    ProcessingState.loading: AudioProcessingState.loading,
    ProcessingState.buffering: AudioProcessingState.buffering,
    ProcessingState.ready: AudioProcessingState.ready,
    ProcessingState.completed: AudioProcessingState.completed,
  };

  void publishMediaItem(MediaItem item) => mediaItem.add(item);

  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    playbackState.add(
      playbackState.value.copyWith(
        controls: <MediaControl>[
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const <MediaAction>{MediaAction.seek},
        androidCompactActionIndices: const <int>[0, 1, 2],
        processingState:
            _processingMap[_player.processingState] ?? AudioProcessingState.idle,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );
  }

  @override
  Future<void> play() async {
    unawaited(_player.play());
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> skipToNext() async => onSkipNext?.call();

  @override
  Future<void> skipToPrevious() async => onSkipPrevious?.call();

  @override
  Future<void> stop() async {
    await _player.stop();
    await _eventSub?.cancel();
    _eventSub = null;
    await super.stop();
  }
}

/// Clean wrapper around `just_audio` + `audio_service`.
///
/// When the platform audio channels are unavailable (unit tests, headless CI,
/// desktop without plugins) the service transparently degrades to a
/// state-only simulation so UI and controller logic keep working.
class AudioPlayerService {
  AudioPlayerService({bool headless = false}) : _forceHeadless = headless;

  /// Service that never touches platform channels (tests / demos).
  AudioPlayerService.headless() : _forceHeadless = true;

  static bool _backgroundInitialized = false;

  /// Volume used while a camera-zone chime is playing.
  static const double duckedVolume = 0.25;
  static const double normalVolume = 1.0;

  final bool _forceHeadless;
  AudioPlayer? _player;
  CrimeMapsAudioHandler? _handler;
  bool _platformFailed = false;
  bool _disposed = false;

  final List<StreamSubscription<dynamic>> _subscriptions =
      <StreamSubscription<dynamic>>[];

  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration?> _durationController =
      StreamController<Duration?>.broadcast();
  final StreamController<bool> _playingController =
      StreamController<bool>.broadcast();
  final StreamController<void> _completedController =
      StreamController<void>.broadcast();
  final StreamController<void> _skipNextController =
      StreamController<void>.broadcast();
  final StreamController<void> _skipPreviousController =
      StreamController<void>.broadcast();
  final StreamController<double> _volumeController =
      StreamController<double>.broadcast();

  bool _playing = false;
  Duration _position = Duration.zero;
  Duration? _duration;
  double _volume = normalVolume;
  Timer? _duckHoldTimer;
  Timer? _duckRampTimer;

  /// True when playback is simulated (no platform audio channel).
  bool get isHeadless => _forceHeadless || _platformFailed;
  bool get isPlaying => _playing;
  Duration get position => _position;
  Duration? get duration => _duration;
  double get volume => _volume;

  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration?> get durationStream => _durationController.stream;
  Stream<bool> get playingStream => _playingController.stream;

  /// Emits when the current track finishes naturally.
  Stream<void> get completedStream => _completedController.stream;

  /// Emitted by lock-screen / notification "next" controls.
  Stream<void> get skipNextStream => _skipNextController.stream;
  Stream<void> get skipPreviousStream => _skipPreviousController.stream;
  Stream<double> get volumeStream => _volumeController.stream;

  /// Loads [track] (with background playback metadata) and starts playback.
  Future<void> playTrack(IndieTrack track) async {
    if (_disposed) return;
    _setPosition(Duration.zero);
    _setDuration(Duration(seconds: track.durationSec));

    if (!isHeadless) {
      try {
        final player = await _ensurePlayer();
        final item = MediaItem(
          id: track.id,
          title: track.title,
          artist: track.artistName,
          album: '${track.cityName}, ${track.stateCode}',
          genre: track.genre,
          duration: Duration(seconds: track.durationSec),
          artUri: track.coverArtUrl.isEmpty
              ? null
              : Uri.tryParse(track.coverArtUrl),
        );
        _handler?.publishMediaItem(item);
        final loaded = await player.setUrl(track.audioUrl);
        if (loaded != null) _setDuration(loaded);
        _setPlaying(true);
        unawaited(player.play());
        return;
      } catch (_) {
        _platformFailed = true;
      }
    }
    _setPlaying(true);
  }

  Future<void> resume() async {
    if (_disposed) return;
    if (!isHeadless) {
      try {
        unawaited(_player?.play());
      } catch (_) {
        _platformFailed = true;
      }
    }
    _setPlaying(true);
  }

  Future<void> pause() async {
    if (_disposed) return;
    if (!isHeadless) {
      try {
        await _player?.pause();
      } catch (_) {
        _platformFailed = true;
      }
    }
    _setPlaying(false);
  }

  Future<void> stop() async {
    if (_disposed) return;
    if (!isHeadless) {
      try {
        await _player?.stop();
      } catch (_) {
        _platformFailed = true;
      }
    }
    _setPlaying(false);
    _setPosition(Duration.zero);
  }

  Future<void> seek(Duration position) async {
    if (_disposed) return;
    if (!isHeadless) {
      try {
        await _player?.seek(position);
      } catch (_) {
        _platformFailed = true;
      }
    }
    _setPosition(position);
  }

  /// Briefly ducks music volume to 0.25 for the camera-zone chime, then
  /// smoothly restores it to full volume.
  void duckForCameraChime({
    Duration hold = const Duration(milliseconds: 1200),
    Duration rampDuration = const Duration(milliseconds: 400),
  }) {
    if (_disposed) return;
    _duckHoldTimer?.cancel();
    _duckRampTimer?.cancel();
    _applyVolume(duckedVolume);

    _duckHoldTimer = Timer(hold, () {
      const steps = 8;
      final stepDuration = Duration(
        microseconds: (rampDuration.inMicroseconds / steps).round(),
      );
      var step = 0;
      _duckRampTimer = Timer.periodic(stepDuration, (timer) {
        step++;
        final t = step / steps;
        _applyVolume(duckedVolume + (normalVolume - duckedVolume) * t);
        if (step >= steps) {
          timer.cancel();
          _applyVolume(normalVolume);
        }
      });
    });
  }

  void _applyVolume(double value) {
    _volume = value;
    if (!_volumeController.isClosed) _volumeController.add(value);
    if (!isHeadless) {
      final player = _player;
      if (player != null) {
        unawaited(
          player.setVolume(value).catchError((Object _) {
            _platformFailed = true;
          }),
        );
      }
    }
  }

  Future<AudioPlayer> _ensurePlayer() async {
    final existing = _player;
    if (existing != null) return existing;

    final player = AudioPlayer();
    _player = player;

    _subscriptions
      ..add(
        player.positionStream.listen(
          _setPosition,
          onError: (Object _) {},
        ),
      )
      ..add(
        player.durationStream.listen(
          _setDuration,
          onError: (Object _) {},
        ),
      )
      ..add(
        player.playingStream.listen(
          _setPlaying,
          onError: (Object _) {},
        ),
      )
      ..add(
        player.processingStateStream.listen(
          (state) {
            if (state == ProcessingState.completed) {
              _completedController.add(null);
            }
          },
          onError: (Object _) {},
        ),
      );

    if (!_backgroundInitialized) {
      _backgroundInitialized = true;
      try {
        _handler = await AudioService.init<CrimeMapsAudioHandler>(
          builder: () => CrimeMapsAudioHandler(
            player,
            onSkipNext: () => _skipNextController.add(null),
            onSkipPrevious: () => _skipPreviousController.add(null),
          ),
          config: const AudioServiceConfig(
            androidNotificationChannelId: 'com.crimemaps.geo_radio.audio',
            androidNotificationChannelName: 'Crime Maps Geo-Radio',
            androidNotificationOngoing: true,
          ),
        );
      } catch (_) {
        // Background controls unavailable; in-app playback still works.
        _handler = null;
      }
    }
    return player;
  }

  void _setPosition(Duration value) {
    _position = value;
    if (!_positionController.isClosed) _positionController.add(value);
  }

  void _setDuration(Duration? value) {
    _duration = value;
    if (!_durationController.isClosed) _durationController.add(value);
  }

  void _setPlaying(bool value) {
    if (_playing == value) return;
    _playing = value;
    if (!_playingController.isClosed) _playingController.add(value);
  }

  /// Releases the player, timers, subscriptions and stream controllers.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _duckHoldTimer?.cancel();
    _duckRampTimer?.cancel();
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
    final player = _player;
    _player = null;
    if (player != null) {
      try {
        await player.dispose();
      } catch (_) {}
    }
    await _positionController.close();
    await _durationController.close();
    await _playingController.close();
    await _completedController.close();
    await _skipNextController.close();
    await _skipPreviousController.close();
    await _volumeController.close();
  }
}

@Riverpod(keepAlive: true)
AudioPlayerService audioPlayerService(Ref ref) {
  final service = AudioPlayerService();
  ref.onDispose(() => unawaited(service.dispose()));
  return service;
}
