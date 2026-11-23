import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/track_model.dart';
import 'geo_radio_controller.dart';

/// Indie Artist Discovery & Geo-Radio screen.
///
/// Prioritizes boosted ZIP tracks first, then tracks matching the active city,
/// followed by other cities sorted by play count. Every track card exposes a
/// visible one-click "Report Copyright Infringement (DMCA)" action for DMCA
/// Safe Harbor compliance.
class GeoRadioScreen extends ConsumerWidget {
  const GeoRadioScreen({
    super.key,
    this.onReportDmca,
  });

  final void Function(IndieTrack track)? onReportDmca;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(
      geoRadioControllerProvider.select((s) => s.queue),
    );
    final activeCitySlug = ref.watch(
      geoRadioControllerProvider.select((s) => s.activeCitySlug),
    );
    final activeGenre = ref.watch(
      geoRadioControllerProvider.select((s) => s.genre),
    );
    final currentTrackId = ref.watch(
      geoRadioControllerProvider.select((s) => s.currentTrack?.id),
    );
    final isPlaying = ref.watch(
      geoRadioControllerProvider.select((s) => s.isPlaying),
    );
    final likedIds = ref.watch(
      geoRadioControllerProvider.select((s) => s.likedTrackIds),
    );
    final controller = ref.read(geoRadioControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Indie Geo-Radio'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Refresh queue',
            onPressed: () => unawaited(controller.refreshQueue()),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: <Widget>[
          const _GeoRadioHeaderCard(),
          const SizedBox(height: 12),
          _CitySelectorBar(
            activeCitySlug: activeCitySlug,
            onSelectCity: (city) => unawaited(controller.setCity(city)),
          ),
          const SizedBox(height: 10),
          _GenreSelectorBar(
            activeGenre: activeGenre,
            onSelectGenre: (genre) => unawaited(controller.setGenre(genre)),
          ),
          const SizedBox(height: 16),
          if (queue.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No active indie tracks match the selected filters.',
                  style: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
            )
          else
            for (final track in queue)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _IndieTrackCard(
                  track: track,
                  isCurrent: currentTrackId == track.id,
                  isPlaying: currentTrackId == track.id && isPlaying,
                  isLiked: likedIds.contains(track.id),
                  onPlayOrToggle: () {
                    if (currentTrackId == track.id) {
                      unawaited(controller.togglePlayPause());
                    } else {
                      unawaited(controller.playTrack(track));
                    }
                  },
                  onToggleLike: () =>
                      unawaited(controller.toggleLike(track.id)),
                  onOpenArtistProfile: () =>
                      _showArtistProfileModal(context, track),
                  onReportDmca: () {
                    final callback = onReportDmca;
                    if (callback != null) {
                      callback(track);
                    } else {
                      unawaited(controller.flagTrackDmca(track.id));
                    }
                  },
                ),
              ),
        ],
      ),
    );
  }

  void _showArtistProfileModal(BuildContext context, IndieTrack track) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.accentPurple.withValues(
                      alpha: 0.2,
                    ),
                    child: const Icon(
                      Icons.person_pin_circle_rounded,
                      color: AppTheme.accentPurple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          track.artistName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          '${track.cityName}, ${track.stateCode} • '
                          'ZIP ${track.zipCode} • ${track.genre}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Row(
                      children: <Widget>[
                        Icon(
                          Icons.verified_user_outlined,
                          color: AppTheme.accentEmerald,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '100% Independent Master & Publishing Warranty',
                          style: TextStyle(
                            color: AppTheme.accentEmerald,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Signed by ${track.rightsWarranty.signedName} '
                      '(Attestation ${track.rightsWarranty.version})',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Featured Track: ${track.title}',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${track.playCount} plays • ${track.likeCount} likes',
                    style: const TextStyle(
                      color: AppTheme.accentCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GeoRadioHeaderCard extends StatelessWidget {
  const _GeoRadioHeaderCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.radio_rounded, color: AppTheme.accentPurple),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Hyper-Local Indie Music Discovery',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              'Streaming 100% artist-owned independent tracks prioritized by '
              'your current ZIP code and city. Every track includes a signed '
              '100% ownership warranty and instant DMCA Safe Harbor reporting.',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}

class _CitySelectorBar extends StatelessWidget {
  const _CitySelectorBar({
    required this.activeCitySlug,
    required this.onSelectCity,
  });

  final String? activeCitySlug;
  final void Function(GeoRadioCity city) onSelectCity;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          for (final city in GeoRadioCity.options)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                key: ValueKey<String>('city-pill-${city.slug ?? 'all'}'),
                label: Text(city.label),
                selected: activeCitySlug == city.slug,
                onSelected: (_) => onSelectCity(city),
              ),
            ),
        ],
      ),
    );
  }
}

class _GenreSelectorBar extends StatelessWidget {
  const _GenreSelectorBar({
    required this.activeGenre,
    required this.onSelectGenre,
  });

  final String? activeGenre;
  final void Function(String? genre) onSelectGenre;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('All Genres'),
              selected: activeGenre == null,
              onSelected: (_) => onSelectGenre(null),
            ),
          ),
          for (final genre in kGeoRadioGenres)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(genre),
                selected: activeGenre == genre,
                onSelected: (_) =>
                    onSelectGenre(activeGenre == genre ? null : genre),
              ),
            ),
        ],
      ),
    );
  }
}

class _IndieTrackCard extends StatelessWidget {
  const _IndieTrackCard({
    required this.track,
    required this.isCurrent,
    required this.isPlaying,
    required this.isLiked,
    required this.onPlayOrToggle,
    required this.onToggleLike,
    required this.onOpenArtistProfile,
    required this.onReportDmca,
  });

  final IndieTrack track;
  final bool isCurrent;
  final bool isPlaying;
  final bool isLiked;
  final VoidCallback onPlayOrToggle;
  final VoidCallback onToggleLike;
  final VoidCallback onOpenArtistProfile;
  final VoidCallback onReportDmca;

  static String _formatDuration(int durationSec) {
    final minutes = durationSec ~/ 60;
    final seconds = (durationSec % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final boosted = isTrackBoosted(track);

    return Card(
      key: ValueKey<String>('track-card-${track.id}'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCurrent ? AppTheme.accentCyan : AppTheme.borderSubtle,
          width: isCurrent ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (boosted)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentAmber.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentAmber),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.rocket_launch_rounded,
                        size: 14,
                        color: AppTheme.accentAmber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'BOOSTED • ZIP ${track.boostTargetZip ?? track.zipCode}',
                        style: const TextStyle(
                          color: AppTheme.accentAmber,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Row(
              children: <Widget>[
                IconButton(
                  key: ValueKey<String>('play-track-${track.id}'),
                  onPressed: onPlayOrToggle,
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                    color: AppTheme.accentCyan,
                    size: 38,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        track.title,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      InkWell(
                        onTap: onOpenArtistProfile,
                        child: Text(
                          '${track.artistName} • ${track.cityName}, '
                          '${track.stateCode} (${track.zipCode})',
                          style: const TextStyle(
                            color: AppTheme.accentCyan,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${track.genre} • '
                        '${_formatDuration(track.durationSec)} • '
                        '${track.playCount} plays',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    IconButton(
                      key: ValueKey<String>('like-track-${track.id}'),
                      tooltip: 'Like track',
                      onPressed: onToggleLike,
                      icon: Icon(
                        isLiked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isLiked
                            ? AppTheme.accentCrimson
                            : AppTheme.textSecondary,
                      ),
                    ),
                    Text(
                      '${track.likeCount}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 16),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 4,
              runSpacing: 4,
              children: <Widget>[
                TextButton.icon(
                  onPressed: onOpenArtistProfile,
                  icon: const Icon(Icons.person_outline_rounded, size: 16),
                  label: const Text('Artist Profile'),
                ),
                TextButton.icon(
                  key: ValueKey<String>('dmca-track-${track.id}'),
                  onPressed: onReportDmca,
                  icon: const Icon(
                    Icons.gavel_rounded,
                    size: 16,
                    color: AppTheme.accentAmber,
                  ),
                  label: const Text(
                    'Report Copyright Infringement (DMCA)',
                    style: TextStyle(
                      color: AppTheme.accentAmber,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
