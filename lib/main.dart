import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/services/firebase_bootstrap.dart';
import 'features/camera_radar/data/local_camera_cache.dart';
import 'features/monetization/presentation/ad_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Hive.initFlutter();
    await Hive.openBox<String>(LocalCameraCache.defaultBoxName);
  } catch (_) {
    // Falls back gracefully to in-memory spatial cache.
  }
  await FirebaseBootstrap.initialize();
  unawaited(AdService.initialize());
  runApp(const ProviderScope(child: CrimeMapsApp()));
}
