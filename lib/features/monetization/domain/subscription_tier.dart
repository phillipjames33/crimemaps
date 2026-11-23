import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_tier.freezed.dart';
part 'subscription_tier.g.dart';

enum SubscriptionPlan {
  free,
  proMonthly,
  proAnnual,
}

@freezed
abstract class SavedGeofence with _$SavedGeofence {
  const factory SavedGeofence({
    required String id,
    required String label,
    required double latitude,
    required double longitude,
    required double radiusMeters,
    required String geohashPrefix,
    @Default(true) bool alertsEnabled,
  }) = _SavedGeofence;

  factory SavedGeofence.fromJson(Map<String, dynamic> json) =>
      _$SavedGeofenceFromJson(json);
}

@freezed
abstract class EntitlementState with _$EntitlementState {
  const factory EntitlementState({
    @Default(false) bool isPro,
    @Default(SubscriptionPlan.free) SubscriptionPlan activePlan,
    @Default(<SavedGeofence>[]) List<SavedGeofence> savedGeofences,
    @Default(<String>[]) List<String> subscribedFcmTopics,
    DateTime? renewalDate,
  }) = _EntitlementState;

  factory EntitlementState.fromJson(Map<String, dynamic> json) =>
      _$EntitlementStateFromJson(json);
}

@freezed
abstract class ArtistBoostPackage with _$ArtistBoostPackage {
  const factory ArtistBoostPackage({
    required String productId,
    required String label,
    required int durationHours,
    required String priceDisplay,
    required String description,
  }) = _ArtistBoostPackage;

  factory ArtistBoostPackage.fromJson(Map<String, dynamic> json) =>
      _$ArtistBoostPackageFromJson(json);
}
