import 'package:crime_maps/core/services/fcm_service.dart';
import 'package:crime_maps/core/theme/app_theme.dart';
import 'package:crime_maps/features/monetization/data/revenuecat_monetization_repository.dart';
import 'package:crime_maps/features/monetization/domain/monetization_repository.dart';
import 'package:crime_maps/features/monetization/domain/subscription_tier.dart';
import 'package:crime_maps/features/monetization/presentation/ad_service.dart';
import 'package:crime_maps/features/monetization/presentation/monetization_controller.dart';
import 'package:crime_maps/features/monetization/presentation/paywall_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Monetization Repository Unit Tests', () {
    late MonetizationRepository repository;

    setUp(() {
      repository = RevenueCatMonetizationRepository();
    });

    test('initial entitlement state defaults to Free tier', () async {
      final EntitlementState state = await repository.fetchEntitlements();
      expect(state.isPro, isFalse);
      expect(state.activePlan, equals(SubscriptionPlan.free));
      expect(state.savedGeofences, isNotEmpty);
    });

    test('purchaseProPlan upgrades to Pro and returns future renewal date', () async {
      final EntitlementState monthly =
          await repository.purchaseProPlan(SubscriptionPlan.proMonthly);
      expect(monthly.isPro, isTrue);
      expect(monthly.activePlan, equals(SubscriptionPlan.proMonthly));
      expect(monthly.renewalDate, isNotNull);
      expect(monthly.renewalDate!.isAfter(DateTime.now()), isTrue);

      final EntitlementState annual =
          await repository.purchaseProPlan(SubscriptionPlan.proAnnual);
      expect(annual.isPro, isTrue);
      expect(annual.activePlan, equals(SubscriptionPlan.proAnnual));
      expect(annual.renewalDate, isNotNull);
      expect(annual.renewalDate!.isAfter(DateTime.now().add(const Duration(days: 300))), isTrue);
    });

    test('purchaseArtistBoost returns future boostedUntil timestamp based on package duration', () async {
      final List<ArtistBoostPackage> packages = await repository.fetchBoostPackages();
      expect(packages.length, greaterThanOrEqualTo(3));

      final ArtistBoostPackage zipBoost = packages.firstWhere((p) => p.durationHours == 24);
      final DateTime boostedUntil = await repository.purchaseArtistBoost(
        trackId: 'trk-atl-001',
        targetZip: '30308',
        package: zipBoost,
      );

      expect(boostedUntil.isAfter(DateTime.now().add(const Duration(hours: 23))), isTrue);
    });
  });

  group('MonetizationController Unit Tests (Geofence & FCM Topics)', () {
    test('adding geofence subscribes to geo_{prefix} FCM topic', () async {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);

      // Read controller to initialize
      await container.read(monetizationControllerProvider.future);

      const SavedGeofence fence = SavedGeofence(
        id: 'geo-custom-01',
        label: 'Inman Park Perimeter',
        latitude: 33.7590,
        longitude: -84.3590,
        radiusMeters: 800,
        geohashPrefix: 'dnh2',
        alertsEnabled: true,
      );

      await container.read(monetizationControllerProvider.notifier).addGeofence(fence);

      final EntitlementState state = container.read(monetizationControllerProvider).requireValue;
      expect(state.savedGeofences.any((g) => g.id == 'geo-custom-01'), isTrue);
      expect(state.subscribedFcmTopics.contains('geo_dnh2'), isTrue);

      final FcmTopicService fcm = container.read(fcmTopicServiceProvider);
      if (fcm is FirebaseFcmTopicService) {
        expect(fcm.subscribedTopics.contains('geo_dnh2'), isTrue);
      }
    });
  });

  group('PaywallScreen & FreeTierAdBanner Widget Tests', () {
    testWidgets('PaywallScreen renders feature comparison, pricing, and allows upgrade to Pro',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const PaywallScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify comparison table features
      expect(find.text('Crime Maps Pro'), findsOneWidget);
      expect(find.text('Feature Comparison'), findsOneWidget);
      expect(find.text('Historical Crime Heatmaps'), findsOneWidget);
      expect(find.text('Custom Geofence Alerts'), findsOneWidget);
      expect(find.text('Civic Camera Radar'), findsOneWidget);
      expect(find.text('Indie Geo-Radio'), findsOneWidget);

      // Verify pricing plans
      expect(find.text('Pro Annual'), findsOneWidget);
      expect(find.text('Pro Monthly'), findsOneWidget);

      // Verify Apple Guideline 3.1.2(c) legal & free-removal links
      expect(find.byKey(const Key('paywall_legal_footer')), findsOneWidget);
      expect(find.byKey(const Key('paywall_privacy_link')), findsOneWidget);
      expect(find.byKey(const Key('paywall_terms_link')), findsOneWidget);
      expect(find.byKey(const Key('paywall_removal_link')), findsOneWidget);

      // Tap Upgrade Button
      final Finder upgradeButton = find.byKey(const Key('paywall_upgrade_button'));
      expect(upgradeButton, findsOneWidget);
      await tester.ensureVisible(upgradeButton);
      await tester.pumpAndSettle();
      await tester.tap(upgradeButton);
      await tester.pumpAndSettle();

      // Hero banner should now show PRO Active
      expect(find.text('Crime Maps Pro Active'), findsOneWidget);
    });

    testWidgets('FreeTierAdBanner renders for free users and hides for Pro users',
        (WidgetTester tester) async {
      final ProviderContainer container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const Scaffold(
              body: Column(
                children: <Widget>[
                  Text('Content Area'),
                  FreeTierAdBanner(),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Free tier: sponsor banner must be visible
      expect(find.byKey(const Key('free_tier_ad_banner')), findsOneWidget);
      expect(find.text('GO PRO'), findsOneWidget);

      // Upgrade to Pro
      await container
          .read(monetizationControllerProvider.notifier)
          .upgradeToPro(SubscriptionPlan.proMonthly);
      await tester.pumpAndSettle();

      // Pro tier: banner must completely disappear (SizedBox.shrink)
      expect(find.byKey(const Key('free_tier_ad_banner')), findsNothing);
    });
  });
}
