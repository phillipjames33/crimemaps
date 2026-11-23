import 'subscription_tier.dart';

/// Repository contract for RevenueCat entitlements, Artist Boost IAPs,
/// and user geofence / FCM alert preferences.
abstract class MonetizationRepository {
  Future<EntitlementState> fetchEntitlements();

  Future<EntitlementState> purchaseProPlan(SubscriptionPlan plan);

  Future<EntitlementState> restorePurchases();

  Future<List<ArtistBoostPackage>> fetchBoostPackages();

  Future<DateTime> purchaseArtistBoost({
    required String trackId,
    required String targetZip,
    required ArtistBoostPackage package,
  });

  Future<EntitlementState> saveGeofence(SavedGeofence geofence);

  Future<EntitlementState> removeGeofence(String geofenceId);
}
