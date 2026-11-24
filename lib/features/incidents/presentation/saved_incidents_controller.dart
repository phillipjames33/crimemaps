import 'dart:async';

import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_incidents_controller.g.dart';

/// Persists user-bookmarked public incidents locally via Hive CE (with an
/// automatic in-memory fallback for unit/widget tests or uninitialized boxes).
///
/// Works seamlessly in guest mode with zero Firestore writes.
@Riverpod(keepAlive: true)
class SavedIncidentsController extends _$SavedIncidentsController {
  static const String _boxName = 'saved_incidents_box';
  static const String _idsKey = 'saved_ids';

  @override
  Set<String> build() {
    unawaited(_hydrateFromHive());
    return const <String>{};
  }

  Future<void> _hydrateFromHive() async {
    try {
      final Box<dynamic> box = Hive.isBoxOpen(_boxName)
          ? Hive.box<dynamic>(_boxName)
          : await Hive.openBox<dynamic>(_boxName);
      final dynamic raw = box.get(_idsKey);
      if (raw is List) {
        final hydrated = raw.whereType<String>().toSet();
        if (hydrated.isNotEmpty) {
          state = <String>{...state, ...hydrated};
        }
      }
    } catch (_) {
      // Hive may not be initialized in headless unit tests; stay in-memory.
    }
  }

  Future<void> _persistToHive(Set<String> ids) async {
    try {
      final Box<dynamic> box = Hive.isBoxOpen(_boxName)
          ? Hive.box<dynamic>(_boxName)
          : await Hive.openBox<dynamic>(_boxName);
      await box.put(_idsKey, ids.toList(growable: false));
    } catch (_) {
      // Non-fatal in headless test environments.
    }
  }

  /// Toggles bookmark status for [incidentId] and returns `true` if now saved.
  bool toggleBookmark(String incidentId) {
    final next = <String>{...state};
    final bool nowSaved;
    if (next.contains(incidentId)) {
      next.remove(incidentId);
      nowSaved = false;
    } else {
      next.add(incidentId);
      nowSaved = true;
    }
    state = next;
    unawaited(_persistToHive(next));
    return nowSaved;
  }

  bool isSaved(String incidentId) => state.contains(incidentId);

  void clearAll() {
    state = const <String>{};
    unawaited(_persistToHive(state));
  }
}
