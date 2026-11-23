import 'package:crime_maps/features/geo_radio/data/audio_player_service.dart';
import 'package:crime_maps/features/geo_radio/data/firestore_track_repository.dart';
import 'package:crime_maps/features/geo_radio/domain/track_model.dart';
import 'package:crime_maps/features/geo_radio/presentation/geo_radio_controller.dart';
import 'package:crime_maps/features/geo_radio/presentation/geo_radio_screen.dart';
import 'package:crime_maps/features/geo_radio/presentation/widgets/persistent_mini_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Indie Geo-Radio — Queue Sorting, DMCA Safe Harbor & Widgets', () {
    test(
      'fetchGeoQueue orders boosted target ZIP > matching city > other cities',
      () async {
        final anchor = DateTime.utc(2026, 11, 23, 18);
        final repo = FirestoreTrackRepository(
          clock: () => anchor,
          liveModeOverride: () => false,
        );

        // Boost trk-atl-003 (6,780 plays) for ZIP 30318 so it outranks higher
        // play-count tracks in Atlanta and Chicago.
        await repo.boostTrack(
          trackId: 'trk-atl-003',
          targetZip: '30318',
          boostedUntil: anchor.add(const Duration(days: 2)),
        );

        final queue = await repo.fetchGeoQueue(
          citySlug: 'atlanta',
          zipCode: '30318',
        );

        expect(queue.length, equals(5));
        // 1. Boosted ZIP match (30318) first
        expect(queue[0].id, equals('trk-atl-003'));
        // 2. Remaining Atlanta tracks next (trk-atl-001 has active boost + 14820 plays, trk-atl-002 has 9240 plays)
        expect(queue[1].citySlug, equals('atlanta'));
        expect(queue[2].citySlug, equals('atlanta'));
        // 3. Other cities last, ordered by playCount desc (Chicago 11300 > Savannah 4120)
        expect(queue[3].id, equals('trk-chi-001'));
        expect(queue[4].id, equals('trk-sav-001'));
      },
    );

    test(
      'DMCA flagging immediately hides track from repository and controller queue',
      () async {
        final anchor = DateTime.utc(2026, 11, 23, 18);
        final repo = FirestoreTrackRepository(
          clock: () => anchor,
          liveModeOverride: () => false,
        );
        final audio = AudioPlayerService.headless();
        addTearDown(audio.dispose);

        final container = ProviderContainer(
          overrides: <Override>[
            trackRepositoryProvider.overrideWithValue(repo),
            audioPlayerServiceProvider.overrideWithValue(audio),
          ],
        );
        addTearDown(container.dispose);

        final controller = container.read(geoRadioControllerProvider.notifier);
        await controller.refreshQueue();

        expect(
          container
              .read(geoRadioControllerProvider)
              .queue
              .any((t) => t.id == 'trk-atl-001'),
          isTrue,
        );

        await controller.flagTrackDmca('trk-atl-001');

        final updatedQueue = container.read(geoRadioControllerProvider).queue;
        expect(updatedQueue.any((t) => t.id == 'trk-atl-001'), isFalse);

        final repoQueue = await repo.fetchGeoQueue(
          citySlug: 'atlanta',
          zipCode: '30308',
        );
        expect(repoQueue.any((t) => t.id == 'trk-atl-001'), isFalse);
      },
    );

    testWidgets(
      'PersistentMiniPlayer and GeoRadioScreen render tracks and DMCA actions',
      (tester) async {
        final anchor = DateTime.utc(2026, 11, 23, 18);
        final repo = FirestoreTrackRepository(
          clock: () => anchor,
          liveModeOverride: () => false,
        );
        final audio = AudioPlayerService.headless();
        addTearDown(audio.dispose);

        IndieTrack? reportedFromCard;
        IndieTrack? reportedFromMiniPlayer;

        await tester.pumpWidget(
          ProviderScope(
            overrides: <Override>[
              trackRepositoryProvider.overrideWithValue(repo),
              audioPlayerServiceProvider.overrideWithValue(audio),
            ],
            child: MaterialApp(
              home: Scaffold(
                body: GeoRadioScreen(
                  onReportDmca: (track) => reportedFromCard = track,
                ),
                bottomNavigationBar: PersistentMiniPlayer(
                  onReportDmca: (track) => reportedFromMiniPlayer = track,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // City selector pills are visible.
        expect(find.text('Atlanta'), findsOneWidget);
        expect(find.text('Savannah'), findsOneWidget);
        expect(find.text('Chicago'), findsOneWidget);
        expect(find.text('All Cities'), findsOneWidget);

        // Mini-player renders current track title, artist, and Atlanta, GA tag.
        expect(find.text('Midnight on I-285 (Indie Mix)'), findsWidgets);
        expect(find.text('Atlanta, GA'), findsWidgets);

        // Every visible track card has a "Report Copyright Infringement (DMCA)" button.
        expect(
          find.text('Report Copyright Infringement (DMCA)'),
          findsWidgets,
        );

        // Tap the DMCA action on the first track card.
        final dmcaCardBtn = find.byKey(
          const ValueKey<String>('dmca-track-trk-atl-001'),
        );
        await tester.ensureVisible(dmcaCardBtn);
        await tester.pumpAndSettle();
        await tester.tap(dmcaCardBtn);
        await tester.pump();
        expect(reportedFromCard?.id, equals('trk-atl-001'));

        // Tap the compact DMCA report icon on the persistent mini-player.
        await tester.tap(
          find.byKey(const ValueKey<String>('mini-player-report-dmca')),
        );
        await tester.pump();
        expect(reportedFromMiniPlayer?.id, equals('trk-atl-001'));
      },
    );
  });
}
