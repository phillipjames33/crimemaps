import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../config/app_env.dart';

/// Safely initializes Firebase and connects optional emulators.
/// Falls back gracefully to local seeded mock mode when Firebase native
/// configuration files are not yet provisioned on a developer workstation.
class FirebaseBootstrap {
  static bool _initialized = false;
  static bool get isFirebaseReady => _initialized;

  static Future<bool> initialize() async {
    if (_initialized) return true;
    try {
      await Firebase.initializeApp();
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
