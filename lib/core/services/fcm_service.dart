import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'firebase_bootstrap.dart';

part 'fcm_service.g.dart';

/// Manages Firebase Cloud Messaging topic subscriptions keyed by geohash,
/// city slug, and state code (`geo_{prefix}`, `city_{slug}`, `state_{code}`).
abstract class FcmTopicService {
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  String buildGeoTopic(String geohashPrefix);
  String buildCityTopic(String citySlug);
  String buildStateTopic(String stateCode);
}

class FirebaseFcmTopicService implements FcmTopicService {
  final Set<String> _localTopics = <String>{};

  Set<String> get subscribedTopics => Set<String>.unmodifiable(_localTopics);

  @override
  String buildGeoTopic(String geohashPrefix) =>
      'geo_${geohashPrefix.toLowerCase().trim()}';

  @override
  String buildCityTopic(String citySlug) =>
      'city_${citySlug.toLowerCase().trim().replaceAll(' ', '_')}';

  @override
  String buildStateTopic(String stateCode) =>
      'state_${stateCode.toLowerCase().trim()}';

  @override
  Future<void> subscribeToTopic(String topic) async {
    _localTopics.add(topic);
    if (!FirebaseBootstrap.isFirebaseReady) return;
    try {
      await FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    } catch (_) {
      // Non-fatal in emulator/offline environments.
    }
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    _localTopics.remove(topic);
    if (!FirebaseBootstrap.isFirebaseReady) return;
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    } catch (_) {
      // Non-fatal in emulator/offline environments.
    }
  }
}

@Riverpod(keepAlive: true)
FcmTopicService fcmTopicService(Ref ref) {
  return FirebaseFcmTopicService();
}
