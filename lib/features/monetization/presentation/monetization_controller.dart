import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/services/fcm_service.dart';
import '../data/revenuecat_monetization_repository.dart';
import '../domain/monetization_repository.dart';
import '../domain/subscription_tier.dart';

part 'monetization_controller.g.dart';

@Riverpod(keepAlive: true)
class MonetizationController extends _$MonetizationController {
  @override
  FutureOr<EntitlementState> build() async {
    final MonetizationRepository repo =
        ref.watch(monetizationRepositoryProvider);
    return repo.fetchEntitlements();
  }

  /// Upgrades user to Pro Monthly or Pro Annual.
  Future<void> upgradeToPro(SubscriptionPlan plan) async {
    final MonetizationRepository repo =
        ref.read(monetizationRepositoryProvider);
    state = const AsyncLoading<EntitlementState>();
    state = await AsyncValue.guard(() => repo.purchaseProPlan(plan));
  }

  /// Restores prior App Store / Google Play purchases.
  Future<void> restorePurchases() async {
    final MonetizationRepository repo =
        ref.read(monetizationRepositoryProvider);
    state = const AsyncLoading<EntitlementState>();
    state = await AsyncValue.guard(() => repo.restorePurchases());
  }

  /// Purchases an Artist Boost package to pin a track to a target ZIP or City queue.
  Future<DateTime> purchaseArtistBoost({
    required String trackId,
    required String targetZip,
    required ArtistBoostPackage package,
  }) async {
    final MonetizationRepository repo =
        ref.read(monetizationRepositoryProvider);
    final DateTime boostedUntil = await repo.purchaseArtistBoost(
      trackId: trackId,
      targetZip: targetZip,
      package: package,
    );
    return boostedUntil;
  }

  /// Adds a custom geofence and subscribes to its corresponding `geo_{prefix}` FCM topic.
  Future<void> addGeofence(SavedGeofence geofence) async {
    final MonetizationRepository repo =
        ref.read(monetizationRepositoryProvider);
    final EntitlementState newState = await repo.saveGeofence(geofence);

    if (geofence.alertsEnabled) {
      final FcmTopicService fcm = ref.read(fcmTopicServiceProvider);
      final String geoTopic = fcm.buildGeoTopic(geofence.geohashPrefix);
      await fcm.subscribeToTopic(geoTopic);

      final List<String> topics = <String>{
        ...newState.subscribedFcmTopics,
        geoTopic,
      }.toList();

      state = AsyncData<EntitlementState>(
        newState.copyWith(subscribedFcmTopics: topics),
      );
    } else {
      state = AsyncData<EntitlementState>(newState);
    }
  }

  /// Removes a custom geofence and unsubscribes from its FCM topic.
  Future<void> removeGeofence(String geofenceId) async {
    final MonetizationRepository repo =
        ref.read(monetizationRepositoryProvider);

    final List<SavedGeofence> existing =
        state.valueOrNull?.savedGeofences ?? <SavedGeofence>[];
    final int index =
        existing.indexWhere((SavedGeofence g) => g.id == geofenceId);

    if (index != -1) {
      final SavedGeofence target = existing[index];
      if (target.alertsEnabled) {
        final FcmTopicService fcm = ref.read(fcmTopicServiceProvider);
        final String geoTopic = fcm.buildGeoTopic(target.geohashPrefix);
        await fcm.unsubscribeFromTopic(geoTopic);
      }
    }

    final EntitlementState newState = await repo.removeGeofence(geofenceId);
    state = AsyncData<EntitlementState>(newState);
  }

  /// Toggles subscription to city, state, or geohash FCM broadcast topics.
  Future<void> toggleFcmTopic(String topic, bool subscribe) async {
    final FcmTopicService fcm = ref.read(fcmTopicServiceProvider);
    if (subscribe) {
      await fcm.subscribeToTopic(topic);
    } else {
      await fcm.unsubscribeFromTopic(topic);
    }

    if (state.hasValue) {
      final Set<String> current =
          Set<String>.from(state.requireValue.subscribedFcmTopics);
      if (subscribe) {
        current.add(topic);
      } else {
        current.remove(topic);
      }
      state = AsyncData<EntitlementState>(
        state.requireValue.copyWith(subscribedFcmTopics: current.toList()),
      );
    }
  }
}
