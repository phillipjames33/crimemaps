import 'package:crime_maps/core/config/compliance_constants.dart';
import 'package:crime_maps/core/theme/app_theme.dart';
import 'package:crime_maps/features/compliance/data/firestore_compliance_repository.dart';
import 'package:crime_maps/features/compliance/domain/compliance_models.dart';
import 'package:crime_maps/features/compliance/domain/compliance_repository.dart';
import 'package:crime_maps/features/compliance/presentation/dmca_report_dialog.dart';
import 'package:crime_maps/features/compliance/presentation/mugshot_removal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Compliance Repository Unit Tests', () {
    late ComplianceRepository repository;

    setUp(() {
      repository = FirestoreComplianceRepository();
    });

    test('submitMugshotRemoval stores request and returns with pending status', () async {
      final MugshotRemovalRequest request = MugshotRemovalRequest(
        id: 'rem-unit-01',
        incidentId: 'inc-atl-001',
        requesterName: 'Jane Doe',
        requesterEmail: 'jane@example.com',
        reason: RemovalReason.dismissedOrAcquitted,
        caseNumber: '2026-CR-001',
        submittedAt: DateTime.now().toUtc(),
      );

      final MugshotRemovalRequest result =
          await repository.submitMugshotRemoval(request);
      expect(result.id, equals('rem-unit-01'));
      expect(result.status, equals('redacted_pending_verification'));
    });

    test('submitDmcaClaim stores claim and returns with soft-hidden status', () async {
      final DmcaClaim claim = DmcaClaim(
        id: 'dmca-unit-01',
        trackId: 'trk-atl-001',
        trackTitle: 'Midnight on I-285',
        claimantName: 'Label Representative',
        claimantEmail: 'legal@recordlabel.com',
        copyrightedWorkDescription: 'Original sound recording ISWC-T-123456',
        goodFaithBeliefConfirmed: true,
        perjuryStatementConfirmed: true,
        electronicSignature: 'John Hancock',
        submittedAt: DateTime.now().toUtc(),
      );

      final DmcaClaim result = await repository.submitDmcaClaim(claim);
      expect(result.id, equals('dmca-unit-01'));
      expect(result.status, equals('track_soft_hidden'));
    });
  });

  group('MugshotRemovalSheet Widget Tests (100% Free & Legal Disclaimer)', () {
    testWidgets('displays 100% free banner, presumed innocent disclaimer, and submits redaction',
        (WidgetTester tester) async {
      bool wasRedacted = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    key: const Key('open_sheet_button'),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (_) => MugshotRemovalSheet(
                          incidentId: 'inc-atl-001',
                          offenderName: 'Marcus D. Ellison',
                          onRedacted: () {
                            wasRedacted = true;
                          },
                        ),
                      );
                    },
                    child: const Text('Open Removal Sheet'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      // Open bottom sheet
      await tester.tap(find.byKey(const Key('open_sheet_button')));
      await tester.pumpAndSettle();

      // 1. Mandatory 100% FREE check: Never gated behind a paywall
      expect(
        find.text(
          '100% Free — Crime Maps never charges to remove or expunge arrest records',
        ),
        findsOneWidget,
      );

      // 2. Mandatory Presumed Innocent disclaimer check
      expect(
        find.text(ComplianceConstants.presumedInnocentDisclaimer),
        findsOneWidget,
      );

      // 3. Fill in required fields
      await tester.enterText(
        find.byKey(const Key('removal_name_field')),
        'Marcus Ellison',
      );
      await tester.enterText(
        find.byKey(const Key('removal_email_field')),
        'marcus@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('removal_case_number_field')),
        '2026-CR-88412',
      );
      await tester.pumpAndSettle();

      // Submit
      final Finder submitButton = find.byKey(const Key('removal_submit_button'));
      expect(submitButton, findsOneWidget);
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Verify callback was called
      expect(wasRedacted, isTrue);
    });
  });

  group('DmcaReportDialog Widget Tests (Enforces Good Faith, Perjury, Signature)', () {
    testWidgets('enforces checkboxes and digital signature before allowing DMCA takedown',
        (WidgetTester tester) async {
      bool wasFlagged = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: Scaffold(
              body: DmcaReportDialog(
                trackId: 'trk-atl-001',
                trackTitle: 'Midnight on I-285',
                onFlagged: () {
                  wasFlagged = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final Finder submitButton = find.byKey(const Key('dmca_submit_button'));
      expect(submitButton, findsOneWidget);

      // Button should be disabled initially
      ElevatedButton btn = tester.widget<ElevatedButton>(submitButton);
      expect(btn.onPressed, isNull);

      // Fill in text fields
      await tester.enterText(
        find.byKey(const Key('dmca_claimant_name_field')),
        'Legal Counsel',
      );
      await tester.enterText(
        find.byKey(const Key('dmca_claimant_email_field')),
        'legal@label.com',
      );
      await tester.enterText(
        find.byKey(const Key('dmca_work_description_field')),
        'Original copyrighted master recording',
      );
      await tester.pumpAndSettle();

      // Still disabled without checkboxes and signature
      btn = tester.widget<ElevatedButton>(submitButton);
      expect(btn.onPressed, isNull);

      // Toggle good faith checkbox
      final Finder goodFaithFinder = find.byKey(const Key('dmca_good_faith_checkbox'));
      await tester.ensureVisible(goodFaithFinder);
      await tester.pumpAndSettle();
      await tester.tap(goodFaithFinder);
      await tester.pumpAndSettle();

      btn = tester.widget<ElevatedButton>(submitButton);
      expect(btn.onPressed, isNull);

      // Toggle perjury checkbox
      final Finder perjuryFinder = find.byKey(const Key('dmca_perjury_checkbox'));
      await tester.ensureVisible(perjuryFinder);
      await tester.pumpAndSettle();
      await tester.tap(perjuryFinder);
      await tester.pumpAndSettle();

      btn = tester.widget<ElevatedButton>(submitButton);
      expect(btn.onPressed, isNull);

      // Enter electronic signature
      final Finder signatureFinder = find.byKey(const Key('dmca_signature_field'));
      await tester.ensureVisible(signatureFinder);
      await tester.pumpAndSettle();
      await tester.enterText(
        signatureFinder,
        'Attorney Jane Doe',
      );
      await tester.pumpAndSettle();

      // Now button is enabled
      btn = tester.widget<ElevatedButton>(submitButton);
      expect(btn.onPressed, isNotNull);

      // Tap submit
      await tester.ensureVisible(submitButton);
      await tester.pumpAndSettle();
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(wasFlagged, isTrue);
    });
  });
}
