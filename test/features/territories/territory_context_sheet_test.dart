import 'package:crime_maps/core/config/compliance_constants.dart';
import 'package:crime_maps/core/mock/seed_data.dart';
import 'package:crime_maps/core/theme/app_theme.dart';
import 'package:crime_maps/features/territories/data/firestore_territory_repository.dart';
import 'package:crime_maps/features/territories/domain/territory_model.dart';
import 'package:crime_maps/features/territories/presentation/territory_providers.dart';
import 'package:crime_maps/features/territories/presentation/widgets/territory_context_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TerritoryContextSheet & moderated territory_submissions queue', () {
    final sampleTerritory = SeedData.buildSeedTerritories().first;

    testWidgets(
      'displays mandatory historical context label, citationDate, sourceReference, and submits corrections to territory_submissions',
      (WidgetTester tester) async {
        final mockRepo = FirestoreTerritoryRepository(forceMockMode: true);

        await tester.pumpWidget(
          ProviderScope(
            overrides: <Override>[
              territoryRepositoryProvider.overrideWithValue(mockRepo),
            ],
            child: MaterialApp(
              theme: AppTheme.darkTheme,
              home: Scaffold(
                body: TerritoryContextSheet(territory: sampleTerritory),
              ),
            ),
          ),
        );

        // Mandatory historical neighborhood context label
        expect(
          find.text('Historical / Publicly Documented Neighborhood Context'),
          findsOneWidget,
        );
        expect(
          find.text(ComplianceConstants.historicalTerritoryLabel),
          findsOneWidget,
        );

        // Required citation metadata
        expect(find.text(sampleTerritory.name), findsOneWidget);
        expect(find.text(sampleTerritory.citationDate), findsOneWidget);
        expect(find.text(sampleTerritory.sourceReference), findsOneWidget);

        // Open community suggestion dialog
        final suggestButton = find.text('Suggest Historical Correction');
        expect(suggestButton, findsOneWidget);
        await tester.tap(suggestButton);
        await tester.pumpAndSettle();

        expect(
          find.textContaining('territory_submissions'),
          findsOneWidget,
        );

        // Enter correction notes and submit
        final textFields = find.byType(TextFormField);
        expect(textFields, findsNWidgets(3));
        await tester.enterText(
          textFields.at(2),
          'Updated eastern boundary per 2025 municipal archive briefing.',
        );

        await tester.tap(find.text('Submit for Moderation'));
        await tester.pumpAndSettle();

        // Verify submission landed in territory_submissions moderation queue
        expect(mockRepo.localSubmissions, hasLength(1));
        final TerritorySubmission saved = mockRepo.localSubmissions.first;
        expect(saved.territoryId, equals(sampleTerritory.id));
        expect(saved.moderationStatus, equals('pending_review'));
        expect(
          saved.notes,
          equals(
            'Updated eastern boundary per 2025 municipal archive briefing.',
          ),
        );

        // Verify live territories collection remains untouched
        final liveTerritories = await mockRepo.fetchTerritories(
          citySlug: 'atlanta',
          stateCode: 'GA',
        );
        expect(liveTerritories.first.name, equals(sampleTerritory.name));
      },
    );
  });
}
