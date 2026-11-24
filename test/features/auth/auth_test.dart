import 'package:crime_maps/core/theme/app_theme.dart';
import 'package:crime_maps/features/auth/domain/auth_user.dart';
import 'package:crime_maps/features/auth/presentation/auth_controller.dart';
import 'package:crime_maps/features/auth/presentation/auth_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthController & AuthSheet Tests', () {
    test('signUpWithEmail, signOut, and signInWithProvider update state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(authControllerProvider).isAuthenticated, isFalse);

      final created = await container
          .read(authControllerProvider.notifier)
          .signUpWithEmail(
            email: 'artist@crimemaps.dev',
            password: 'securePassword1',
            displayName: 'Zone Six Indie',
            isArtist: true,
          );
      expect(created, isTrue);

      final signedInState = container.read(authControllerProvider);
      expect(signedInState.isAuthenticated, isTrue);
      expect(signedInState.user?.displayName, equals('Zone Six Indie'));
      expect(signedInState.user?.isArtist, isTrue);

      await container.read(authControllerProvider.notifier).signOut();
      expect(container.read(authControllerProvider).isAuthenticated, isFalse);

      final googleOk = await container
          .read(authControllerProvider.notifier)
          .signInWithProvider(AuthProviderType.google);
      expect(googleOk, isTrue);
      expect(
        container.read(authControllerProvider).user?.provider,
        equals(AuthProviderType.google),
      );
    });

    test('signInWithEmail rejects short passwords cleanly', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final ok = await container
          .read(authControllerProvider.notifier)
          .signInWithEmail(email: 'user@example.com', password: '123');
      expect(ok, isFalse);
      expect(
        container.read(authControllerProvider).errorMessage,
        contains('at least 6 characters'),
      );
    });

    testWidgets('AuthSheet renders guest notice and completes email sign-in', (
      WidgetTester tester,
    ) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: AuthSheet(),
            ),
          ),
        ),
      );

      expect(find.text('Sign In to Crime Maps'), findsOneWidget);
      expect(
        find.textContaining('100% free record removal requests never require an account'),
        findsOneWidget,
      );

      await tester.enterText(
        find.byKey(const Key('auth_email_field')),
        'phillip@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('auth_password_field')),
        'password123',
      );
      await tester.ensureVisible(find.byKey(const Key('auth_submit_button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('auth_submit_button')));
      await tester.pumpAndSettle();

      expect(container.read(authControllerProvider).isAuthenticated, isTrue);
      expect(
        container.read(authControllerProvider).user?.email,
        equals('phillip@example.com'),
      );
    });

    test('deleteAccount permanently clears signed-in user state', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(authControllerProvider.notifier).signUpWithEmail(
            email: 'delete-me@crimemaps.dev',
            password: 'password123',
            displayName: 'Temp User',
          );
      expect(container.read(authControllerProvider).isAuthenticated, isTrue);

      final deleted =
          await container.read(authControllerProvider.notifier).deleteAccount();
      expect(deleted, isTrue);
      expect(container.read(authControllerProvider).isAuthenticated, isFalse);
      expect(container.read(authControllerProvider).user, isNull);
    });
  });
}
