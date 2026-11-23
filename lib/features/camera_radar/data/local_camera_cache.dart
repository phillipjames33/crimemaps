import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/geo/geohash_util.dart';
import '../domain/camera_model.dart';

part 'local_camera_cache.g.dart';

/// Local spatial cache of public infrastructure cameras keyed by geohash cell
/// (see `GeohashUtil.cellKey`).
///
/// Real-time "Entering Public Camera Zone" proximity checks run exclusively
/// against this cache, so GPS ticks NEVER hit Firestore. Entries are persisted
/// to a `hive_ce` box when one can be opened and transparently fall back to an
/// in-memory map otherwise (unit tests, headless runs, Hive not initialized).
class LocalCameraCache {
  LocalCameraCache({
    String boxName = defaultBoxName,
    DateTime Function()? clock,
  })  : _boxName = boxName,
        _clock = clock ?? DateTime.now;

  static const String defaultBoxName = 'camera_spatial_cache_v1';

  final String _boxName;
  final DateTime Function() _clock;
  final Map<String, _CacheEntry> _memory = <String, _CacheEntry>{};
  Box<String>? _box;

  /// True when entries are also persisted to a Hive box.
  bool get isPersistent => _box != null && (_box?.isOpen ?? false);

  /// Cell keys currently held in memory.
  Set<String> get cellKeys => Set<String>.unmodifiable(_memory.keys);

  /// Attempts to open the backing Hive box. Never throws: when Hive is not
  /// initialized the cache silently keeps working in memory only.
  Future<void> open() async {
    if (isPersistent) return;
    try {
      if (Hive.isBoxOpen(_boxName)) {
        _box = Hive.box<String>(_boxName);
      } else {
        _box = await Hive.openBox<String>(_boxName);
      }
    } catch (_) {
      _box = null;
    }
  }

  /// Returns true when a fresh (non-stale) entry exists for [cellKey].
  bool hasFreshCell(
    String cellKey, {
    Duration maxAge = const Duration(hours: 24),
  }) {
    return getCell(cellKey, maxAge: maxAge) != null;
  }

  /// Returns cached cameras for [cellKey], or `null` on a miss / stale entry.
  List<PublicCamera>? getCell(
    String cellKey, {
    Duration maxAge = const Duration(hours: 24),
  }) {
    var entry = _memory[cellKey];
    if (entry == null) {
      final raw = isPersistent ? _box?.get(cellKey) : null;
      if (raw != null) {
        entry = _CacheEntry.tryDecode(raw);
        if (entry != null) _memory[cellKey] = entry;
      }
    }
    if (entry == null) return null;
    if (_clock().difference(entry.fetchedAt) > maxAge) return null;
    return List<PublicCamera>.unmodifiable(entry.cameras);
  }

  /// Stores [cameras] for [cellKey] (JSON maps in Hive, objects in memory).
  Future<void> putCell(String cellKey, List<PublicCamera> cameras) async {
    final entry = _CacheEntry(
      fetchedAt: _clock(),
      cameras: List<PublicCamera>.of(cameras),
    );
    _memory[cellKey] = entry;
    if (isPersistent) {
      try {
        await _box?.put(cellKey, entry.encode());
      } catch (_) {
        // Persistence is best-effort; the in-memory copy remains valid.
      }
    }
  }

  /// Convenience: cached cameras within [radiusMeters] of a position, sorted
  /// nearest first. Purely local Haversine math.
  List<({PublicCamera camera, double distanceMeters})> camerasNear({
    required double latitude,
    required double longitude,
    required double radiusMeters,
    int precision = 5,
  }) {
    final cell = GeohashUtil.cellKey(latitude, longitude, precision: precision);
    final cameras = getCell(cell) ?? const <PublicCamera>[];
    final results = <({PublicCamera camera, double distanceMeters})>[];
    for (final camera in cameras) {
      final distance = GeohashUtil.haversineDistanceMeters(
        lat1: latitude,
        lng1: longitude,
        lat2: camera.latitude,
        lng2: camera.longitude,
      );
      if (distance <= radiusMeters) {
        results.add((camera: camera, distanceMeters: distance));
      }
    }
    results.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return results;
  }

  /// Removes a single cell so the next lookup is a miss.
  Future<void> evictCell(String cellKey) async {
    _memory.remove(cellKey);
    if (isPersistent) {
      try {
        await _box?.delete(cellKey);
      } catch (_) {}
    }
  }

  Future<void> clear() async {
    _memory.clear();
    if (isPersistent) {
      try {
        await _box?.clear();
      } catch (_) {}
    }
  }

  Future<void> close() async {
    final box = _box;
    _box = null;
    if (box != null && box.isOpen) {
      try {
        await box.close();
      } catch (_) {}
    }
  }
}

class _CacheEntry {
  const _CacheEntry({required this.fetchedAt, required this.cameras});

  final DateTime fetchedAt;
  final List<PublicCamera> cameras;

  String encode() {
    return jsonEncode(<String, dynamic>{
      'fetchedAt': fetchedAt.toUtc().toIso8601String(),
      'cameras': cameras
          .map((camera) => camera.toJson())
          .toList(growable: false),
    });
  }

  static _CacheEntry? tryDecode(String raw) {
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final fetchedAt = DateTime.parse(decoded['fetchedAt'] as String);
      final list = decoded['cameras'] as List<dynamic>;
      final cameras = list
          .map(
            (dynamic item) =>
                PublicCamera.fromJson(item as Map<String, dynamic>),
          )
          .toList(growable: false);
      return _CacheEntry(fetchedAt: fetchedAt, cameras: cameras);
    } catch (_) {
      return null;
    }
  }
}

@Riverpod(keepAlive: true)
LocalCameraCache localCameraCache(Ref ref) {
  final cache = LocalCameraCache();
  unawaited(cache.open());
  ref.onDispose(() => unawaited(cache.close()));
  return cache;
}
