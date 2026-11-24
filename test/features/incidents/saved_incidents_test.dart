import 'package:crime_maps/core/mock/seed_data.dart';
import 'package:crime_maps/core/theme/app_theme.dart';
import 'package:crime_maps/features/incidents/presentation/saved_incidents_controller.dart';
import 'package:crime_maps/features/incidents/presentation/widgets/incident_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SavedIncidentsController & IncidentDetailSheet Bookmarks', () {
    test('toggleBookmark adds, removes, and clearAll resets saved IDs', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier =
          container.read(savedIncidentsControllerProvider.notifier);
      expect(container.read(savedIncidentsControllerProvider), isEmpty);

      final added = notifier.toggleBookmark('inc-atl-001');
      expect(added, isTrue);
      expect(notifier.isSaved('inc-atl-001'), isTrue);
      expect(container.read(savedIncidentsControllerProvider),
          contains('inc-atl-001'));

      final removed = notifier.toggleBookmark('inc-atl-001');
      expect(removed, isFalse);
      expect(notifier.isSaved('inc-atl-001'), isFalse);

      notifier.toggleBookmark('inc-atl-002');
      notifier.clearAll();
      expect(container.read(savedIncidentsControllerProvider), isEmpty);
    });

    testWidgets(
      'IncidentDetailSheet bookmark icon toggles saved state cleanly',
      (WidgetTester tester) async {
        final incident = SeedData.buildSeedIncidents().first;
        final container = ProviderContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: Scaffold(
                body: IncidentDetailSheet(incident: incident),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final bookmarkBtn = find.byKey(const Key('incident_bookmark_button'));
        expect(bookmarkBtn, findsOneWidget);
        expect(
          container.read(savedIncidentsControllerProvider).contains(incident.id),
          isFalse,
        );

        await tester.tap(bookmarkBtn);
        await tester.pumpAndSettle();

        expect(
          container.read(savedIncidentsControllerProvider).contains(incident.id),
          isTrue,
        );
        expect(
          find.text('Incident saved to your local bookmarks.'),
          findsOneWidget,
        );
      },
    );
  });
}
