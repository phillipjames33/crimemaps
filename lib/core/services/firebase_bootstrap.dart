import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

import '../config/app_env.dart';

/// Safely initializes Firebase, activates Firebase App Check when appropriate,
/// and connects optional emulators.
/// Reads Web Firebase options from `--dart-define` / `.env` (zero hardcoded
/// API keys in `lib/`), uses native `google-services.json` /
/// `GoogleService-Info.plist` on Android & iOS, and falls back gracefully to
/// local seeded mock mode when Firebase is not yet provisioned.
class FirebaseBootstrap {
  static bool _initialized = false;
  static bool _appCheckActivated = false;

  static bool get isFirebaseReady => _initialized;
  static bool get isAppCheckActivated => _appCheckActivated;

  static Future<bool> initialize() async {
    if (_initialized) return true;
    try {
      if (kIsWeb) {
        if (!AppEnv.hasFirebaseWebOptions) return false;
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: AppEnv.firebaseApiKey,
            appId: AppEnv.firebaseAppId,
            messagingSenderId: AppEnv.firebaseMessagingSenderId,
            projectId: AppEnv.firebaseProjectId,
            authDomain: AppEnv.firebaseAuthDomain,
            storageBucket: AppEnv.firebaseStorageBucket,
          ),
        );
      } else {
        await Firebase.initializeApp();
      }

      if (AppEnv.useFirebaseEmulators) {
        const host = AppEnv.firebaseEmulatorHost;
        FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
        await FirebaseAuth.instance.useAuthEmulator(host, 9099);
        FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
        await FirebaseStorage.instance.useStorageEmulator(host, 9199);
      } else {
        // Non-blocking so attestation handshake never delays initial streams.
        unawaited(_activateAppCheck());
      }
      _initialized = true;
      return true;
    } catch (_) {
      _initialized = false;
      return false;
    }
  }

  /// Activates Firebase App Check using platform-native attestation:
  /// - Android: Play Integrity (release) / Debug provider (debug)
  /// - iOS: App Attest with DeviceCheck fallback (release) / Debug (debug)
  /// - Web: reCAPTCHA v3 when `RECAPTCHA_V3_SITE_KEY` is provided
  ///
  /// Non-fatal on emulators or environments without attestation credentials.
  static Future<void> _activateAppCheck() async {
    if (_appCheckActivated) return;
    try {
      if (kIsWeb) {
        if (!AppEnv.hasRecaptchaV3SiteKey) return;
        await FirebaseAppCheck.instance.activate(
          webProvider: ReCaptchaV3Provider(AppEnv.recaptchaV3SiteKey),
        );
      } else {
        await FirebaseAppCheck.instance.activate(
          androidProvider:
              kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
          appleProvider: kDebugMode
              ? AppleProvider.debug
              : AppleProvider.appAttestWithDeviceCheckFallback,
        );
      }
      _appCheckActivated = true;
    } catch (_) {
      _appCheckActivated = false;
    }
  }
}
