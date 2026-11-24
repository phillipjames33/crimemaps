import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../config/app_env.dart';

/// Safely initializes Firebase and connects optional emulators.
/// Reads Web Firebase options from `--dart-define` / `.env` (zero hardcoded
/// API keys in `lib/`) and falls back gracefully to local seeded mock mode
/// when native Firebase configuration files are not yet provisioned.
class FirebaseBootstrap {
  static bool _initialized = false;
  static bool get isFirebaseReady => _initialized;

  static Future<bool> initialize() async {
    if (_initialized) return true;
    try {
      if (AppEnv.hasFirebaseWebOptions) {
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
      } else if (!kIsWeb) {
        await Firebase.initializeApp();
      } else {
        return false;
      }

      if (AppEnv.useFirebaseEmulators) {
        const host = AppEnv.firebaseEmulatorHost;
        FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
        await FirebaseAuth.instance.useAuthEmulator(host, 9099);
        FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
        await FirebaseStorage.instance.useStorageEmulator(host, 9199);
      }
      _initialized = true;
      return true;
    } catch (_) {
      _initialized = false;
      return false;
    }
  }
}
