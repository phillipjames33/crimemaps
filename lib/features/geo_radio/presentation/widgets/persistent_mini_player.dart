import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/track_model.dart';
import '../geo_radio_controller.dart';

/// Persistent indie Geo-Radio mini-player docked directly above the bottom
/// navigation bar across all shell tabs.
class PersistentMiniPlayer extends ConsumerWidget {
  const PersistentMiniPlayer({
    super.key,
    this.onReportDmca,
  });

  final void Function(IndieTrack track)? onReportDmca;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(
      geoRadioControllerProvider.select(
        (s) => s.currentTrack ?? (s.queue.isNotEmpty ? s.queue.first : null),
      ),
    );
    final isPlaying = ref.watch(
      geoRadioControllerProvider.select((s) => s.isPlaying),
    );

    if (track == null) {
      return const SizedBox.shrink();
    }

    final controller = ref.read(geoRadioControllerProvider.notifier);

    return Material(
      color: AppTheme.surfaceElevated,
      child: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surfaceElevated,
          border: Border(
            top: BorderSide(color: AppTheme.borderSubtle),
            bottom: BorderSide(color: AppTheme.borderSubtle),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const _MiniPlayerProgressScrubber(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: <Widget>[
                  _CoverArtThumbnail(coverArtUrl: track.coverArtUrl),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                track.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentCyan.withValues(
                                  alpha: 0.14,
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${track.cityName}, ${track.stateCode}',
                                style: const TextStyle(
                                  color: AppTheme.accentCyan,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          track.artistName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: const ValueKey<String>('mini-player-play-pause'),
                    tooltip: isPlaying ? 'Pause' : 'Play',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => unawaited(controller.togglePlayPause()),
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: AppTheme.accentCyan,
                      size: 30,
                    ),
                  ),
                  IconButton(
                    key: const ValueKey<String>('mini-player-skip-next'),
                    tooltip: 'Next track',
                    visualDensity: VisualDensity.compact,
                    onPressed: () => unawaited(controller.next()),
                    icon: const Icon(
                      Icons.skip_next_rounded,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    key: const ValueKey<String>('mini-player-report-dmca'),
                    tooltip: 'Report DMCA',
                    visualDensity: VisualDensity.compact,
                    onPressed: () {
                      final callback = onReportDmca;
                      if (callback != null) {
                        callback(track);
                      } else {
                        unawaited(controller.flagTrackDmca(track.id));
                      }
                    },
                    icon: const Icon(
                      Icons.flag_outlined,
                      color: AppTheme.accentAmber,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Scoped progress scrubber that watches only playback `position` and
/// `duration` via `.select(...)` to avoid rebuilding the entire mini-player
/// on every audio position tick.
class _MiniPlayerProgressScrubber extends ConsumerWidget {
  const _MiniPlayerProgressScrubber();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(
      geoRadioControllerProvider.select((s) {
        final totalMs = s.duration.inMilliseconds;
        if (totalMs <= 0) return 0.0;
        final ratio = s.position.inMilliseconds / totalMs;
        return ratio.clamp(0.0, 1.0);
      }),
    );

    return LinearProgressIndicator(
      value: progress,
      minHeight: 2.5,
      backgroundColor: AppTheme.surfaceDark,
      color: AppTheme.accentCyan,
    );
  }
}

class _CoverArtThumbnail extends StatelessWidget {
  const _CoverArtThumbnail({required this.coverArtUrl});

  final String coverArtUrl;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: const Icon(
        Icons.album_rounded,
        color: AppTheme.accentPurple,
        size: 22,
      ),
    );

    if (coverArtUrl.trim().isEmpty) {
      return placeholder;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        imageUrl: coverArtUrl,
        width: 42,
        height: 42,
        fit: BoxFit.cover,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => placeholder,
      ),
    );
  }
}
