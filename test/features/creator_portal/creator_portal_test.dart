import 'package:crime_maps/core/config/compliance_constants.dart';
import 'package:crime_maps/core/theme/app_theme.dart';
import 'package:crime_maps/features/creator_portal/data/creator_upload_repository.dart';
import 'package:crime_maps/features/creator_portal/domain/track_upload_request.dart';
import 'package:crime_maps/features/creator_portal/presentation/creator_portal_screen.dart';
import 'package:crime_maps/features/geo_radio/domain/track_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CreatorUploadRepository Unit Tests', () {
    late CreatorUploadRepository repository;

    setUp(() {
      repository = CreatorUploadRepositoryImpl();
    });

    test('blocks upload with RightsWarrantyViolationException when owns100Percent is false', () async {
      final TrackUploadRequest request = TrackUploadRequest(
        artistId: 'artist-test',
        artistName: 'Test Artist',
        title: 'Test Song',
        genre: 'Southern Hip-Hop',
        citySlug: 'atlanta',
        cityName: 'Atlanta',
        stateCode: 'GA',
        zipCode: '30308',
        audioFileName: 'song.mp3',
        audioMimeType: 'audio/mpeg',
        audioSizeBytes: 1024 * 1024,
        owns100Percent: false,
        signedName: 'Valid Signature',
        signedAt: DateTime.now().toUtc(),
        attestationVersion: ComplianceConstants.rightsAttestationVersion,
      );

      expect(
        () => repository.uploadTrack(request),
        throwsA(isA<RightsWarrantyViolationException>()),
      );
    });

    test('blocks upload with RightsWarrantyViolationException when signedName is too short', () async {
      final TrackUploadRequest request = TrackUploadRequest(
        artistId: 'artist-test',
        artistName: 'Test Artist',
        title: 'Test Song',
        genre: 'Southern Hip-Hop',
        citySlug: 'atlanta',
        cityName: 'Atlanta',
        stateCode: 'GA',
        zipCode: '30308',
        audioFileName: 'song.mp3',
        audioMimeType: 'audio/mpeg',
        audioSizeBytes: 1024 * 1024,
        owns100Percent: true,
        signedName: 'A',
        signedAt: DateTime.now().toUtc(),
        attestationVersion: ComplianceConstants.rightsAttestationVersion,
      );

      expect(
        () => repository.uploadTrack(request),
        throwsA(isA<RightsWarrantyViolationException>()),
      );
    });

    test('blocks upload with RightsWarrantyViolationException when audio MIME is invalid', () async {
      final TrackUploadRequest request = TrackUploadRequest(
        artistId: 'artist-test',
        artistName: 'Test Artist',
        title: 'Test Song',
        genre: 'Southern Hip-Hop',
        citySlug: 'atlanta',
        cityName: 'Atlanta',
        stateCode: 'GA',
        zipCode: '30308',
        audioFileName: 'song.ogg',
        audioMimeType: 'audio/ogg',
        audioSizeBytes: 1024 * 1024,
        owns100Percent: true,
        signedName: 'Valid Signature',
        signedAt: DateTime.now().toUtc(),
        attestationVersion: ComplianceConstants.rightsAttestationVersion,
      );

      expect(
        () => repository.uploadTrack(request),
        throwsA(isA<RightsWarrantyViolationException>()),
      );
    });

    test('blocks upload with RightsWarrantyViolationException when file exceeds 25 MB', () async {
      final TrackUploadRequest request = TrackUploadRequest(
        artistId: 'artist-test',
        artistName: 'Test Artist',
        title: 'Test Song',
        genre: 'Southern Hip-Hop',
        citySlug: 'atlanta',
        cityName: 'Atlanta',
        stateCode: 'GA',
        zipCode: '30308',
        audioFileName: 'song.mp3',
        audioMimeType: 'audio/mpeg',
        audioSizeBytes: ComplianceConstants.maxAudioUploadBytes + 1,
        owns100Percent: true,
        signedName: 'Valid Signature',
        signedAt: DateTime.now().toUtc(),
        attestationVersion: ComplianceConstants.rightsAttestationVersion,
      );

      expect(
        () => repository.uploadTrack(request),
        throwsA(isA<RightsWarrantyViolationException>()),
      );
    });

    test('succeeds and creates IndieTrack when warranty, format, and size are valid', () async {
      final TrackUploadRequest request = TrackUploadRequest(
        artistId: 'artist-test',
        artistName: 'Test Artist',
        title: 'Valid Track',
        genre: 'Southern Hip-Hop',
        citySlug: 'atlanta',
        cityName: 'Atlanta',
        stateCode: 'GA',
        zipCode: '30308',
        audioFileName: 'valid.mp3',
        audioMimeType: 'audio/mpeg',
        audioSizeBytes: 3 * 1024 * 1024,
        owns100Percent: true,
        signedName: 'Marcus Vance',
        signedAt: DateTime.now().toUtc(),
        attestationVersion: ComplianceConstants.rightsAttestationVersion,
      );

      final IndieTrack track = await repository.uploadTrack(request);

      expect(track.id, isNotEmpty);
      expect(track.title, equals('Valid Track'));
      expect(track.artistName, equals('Test Artist'));
      expect(track.rightsWarranty.owns100Percent, isTrue);
      expect(track.rightsWarranty.signedName, equals('Marcus Vance'));
      expect(track.status, equals(TrackStatus.active));
    });
  });

  group('CreatorPortalController & Screen Widget Tests', () {
    testWidgets('enforces 100% warranty checkbox and signature before enabling upload', (WidgetTester tester) async {
      IndieTrack? publishedTrack;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: CreatorPortalScreen(
              onTrackPublished: (IndieTrack track) {
                publishedTrack = track;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify portal elements render
      expect(find.text('Creator Portal'), findsOneWidget);
      expect(find.text('Publish New Track'), findsOneWidget);
      expect(find.byKey(const Key('creator_rights_warranty_card')), findsOneWidget);

      final Finder uploadButton = find.byKey(const Key('creator_upload_submit_button'));
      expect(uploadButton, findsOneWidget);

      // Verify button is disabled initially
      final ElevatedButton initialButtonWidget = tester.widget<ElevatedButton>(uploadButton);
      expect(initialButtonWidget.onPressed, isNull);

      // Tap demo audio to fill in audio file, track title, and artist name
      final Finder demoButton = find.byKey(const Key('creator_demo_audio_button'));
      expect(demoButton, findsOneWidget);
      await tester.tap(demoButton);
      await tester.pumpAndSettle();

      // Button should still be disabled because warranty checkbox and signature are missing
      final ElevatedButton postDemoButtonWidget = tester.widget<ElevatedButton>(uploadButton);
      expect(postDemoButtonWidget.onPressed, isNull);

      // Check the 100% rights warranty box
      final Finder checkboxFinder = find.byKey(const Key('creator_warranty_checkbox'));
      await tester.ensureVisible(checkboxFinder);
      await tester.pumpAndSettle();
      await tester.tap(checkboxFinder);
      await tester.pumpAndSettle();

      // Still disabled because signature is empty
      final ElevatedButton postCheckButtonWidget = tester.widget<ElevatedButton>(uploadButton);
      expect(postCheckButtonWidget.onPressed, isNull);

      // Type the legal signature
      final Finder signatureField = find.byKey(const Key('creator_signature_field'));
      await tester.ensureVisible(signatureField);
      await tester.pumpAndSettle();
      await tester.enterText(signatureField, 'Marcus Vance');
      await tester.pumpAndSettle();

      // Now the button MUST be enabled!
      final ElevatedButton enabledButtonWidget = tester.widget<ElevatedButton>(uploadButton);
      expect(enabledButtonWidget.onPressed, isNotNull);

      // Tap upload button
      await tester.ensureVisible(uploadButton);
      await tester.pumpAndSettle();
      await tester.tap(uploadButton);
      await tester.pumpAndSettle();

      // Verify track was published and callback fired
      expect(publishedTrack, isNotNull);
      expect(publishedTrack!.rightsWarranty.owns100Percent, isTrue);
      expect(publishedTrack!.rightsWarranty.signedName, equals('Marcus Vance'));
    });
  });
}
