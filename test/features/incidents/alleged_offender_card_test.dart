import 'package:crime_maps/core/config/compliance_constants.dart';
import 'package:crime_maps/core/theme/app_theme.dart';
import 'package:crime_maps/features/incidents/data/firestore_incident_repository.dart';
import 'package:crime_maps/features/incidents/data/jail_booking_adapter.dart';
import 'package:crime_maps/features/incidents/domain/incident_model.dart';
import 'package:crime_maps/features/incidents/domain/incident_repository.dart';
import 'package:crime_maps/features/incidents/presentation/widgets/alleged_offender_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AllegedOffenderCard compliance & removal flow', () {
    final bookingDate = DateTime.utc(2026, 11, 20, 14, 30);
    final sampleOffender = AllegedOffender(
      name: 'Marcus D. Ellison (Booking #FC-26-88412)',
      bookingPhotoUrl: null,
      charges: const <String>[
        'O.C.G.A. 16-8-41 Armed Robbery (Alleged)',
      ],
      bookingDate: bookingDate,
      sourceAgency: 'Fulton County Sheriff Detention Center',
      disclaimer: ComplianceConstants.presumedInnocentDisclaimer,
      expiresAt: ComplianceConstants.computeBookingExpiry(bookingDate),
    );

    testWidgets(
      'displays mandatory Presumed innocent disclaimer and triggers free removal callback',
      (WidgetTester tester) async {
        var removalRequested = false;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: SingleChildScrollView(
                child: AllegedOffenderCard(
                  offender: sampleOffender,
                  onRequestRemoval: () {
                    removalRequested = true;
                  },
                ),
              ),
            ),
          ),
        );

        // Mandatory legal disclaimer assertion ("Presumed innocent")
        expect(
          find.text(ComplianceConstants.presumedInnocentDisclaimer),
          findsOneWidget,
        );
        expect(
          find.textContaining('presumed innocent', findRichText: true),
          findsOneWidget,
        );

        // Verify booking details & 45-day TTL badge
        expect(find.textContaining('45-Day TTL'), findsOneWidget);
        expect(
          find.text('O.C.G.A. 16-8-41 Armed Robbery (Alleged)'),
          findsOneWidget,
        );
        expect(
          find.textContaining('Fulton County Sheriff Detention Center'),
          findsOneWidget,
        );

        // Verify 100% free removal / expungement button works without paywall
        final removalButton = find.text('Request Record Removal / Expungement');
        expect(removalButton, findsOneWidget);
        expect(find.textContaining('100% Free'), findsOneWidget);

        await tester.tap(removalButton);
        await tester.pumpAndSettle();

        expect(removalRequested, isTrue);
      },
    );

    testWidgets(
      'shows clear redacted notice while keeping Presumed innocent disclaimer visible',
      (WidgetTester tester) async {
        final redactedOffender = sampleOffender.copyWith(redacted: true);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: AllegedOffenderCard(offender: redactedOffender),
            ),
          ),
        );

        expect(find.text('Booking Record Redacted'), findsOneWidget);
        expect(
          find.text(ComplianceConstants.presumedInnocentDisclaimer),
          findsOneWidget,
        );
        expect(find.text(sampleOffender.name), findsNothing);
      },
    );
  });

  group('FirestoreIncidentRepository & CountyJailBookingAdapter', () {
    test('enforces 45-day TTL and Presumed innocent disclaimer in booking adapter',
        () async {
      final adapter = CountyJailBookingAdapter();
      final record = await adapter.lookupBookingForIncident(
        incidentId: 'inc-atl-001',
        citySlug: 'atlanta',
        stateCode: 'GA',
      );

      expect(record, isNotNull);
      expect(
        record!.disclaimer,
        equals(ComplianceConstants.presumedInnocentDisclaimer),
      );
      expect(
        record.expiresAt.difference(record.bookingDate).inDays,
        equals(ComplianceConstants.bookingTtlDays),
      );
    });

    test('filters incidents by area, city, and state scope and supports redaction',
        () async {
      final repo = FirestoreIncidentRepository(forceMockMode: true);
      addTearDown(repo.dispose);

      final areaIncidents = await repo.fetchIncidentsByScope(
        scope: MapScope.area,
        centerLat: 33.7756,
        centerLng: -84.3963,
        citySlug: 'atlanta',
        stateCode: 'GA',
      );
      expect(areaIncidents, isNotEmpty);
      expect(
        areaIncidents.every((Incident i) => i.citySlug == 'atlanta'),
        isTrue,
      );

      final stateIncidents = await repo.fetchIncidentsByScope(
        scope: MapScope.state,
        centerLat: 33.7756,
        centerLng: -84.3963,
        citySlug: 'atlanta',
        stateCode: 'GA',
      );
      expect(
        stateIncidents.any((Incident i) => i.citySlug == 'savannah'),
        isTrue,
      );
      expect(
        stateIncidents.every((Incident i) => i.stateCode == 'GA'),
        isTrue,
      );

      await repo.markOffenderRedacted('inc-atl-001');
      final updated = await repo.getIncidentById('inc-atl-001');
      expect(updated?.allegedOffender?.redacted, isTrue);
    });
  });
}
