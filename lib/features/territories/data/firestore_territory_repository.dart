import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/config/app_env.dart';
import '../../../core/config/compliance_constants.dart';
import '../../../core/mock/seed_data.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../domain/territory_model.dart';
import '../domain/territory_repository.dart';

/// Firestore-backed [TerritoryRepository] with read-only historical territory
/// queries and moderated community correction writes.
///
/// Community edits are written strictly to [submissionsCollection]
/// (`territory_submissions`) and NEVER directly to [territoriesCollection].
class FirestoreTerritoryRepository implements TerritoryRepository {
  FirestoreTerritoryRepository({
    FirebaseFirestore? firestore,
    List<Territory>? initialMockTerritories,
    bool? forceMockMode,
  })  : _firestoreOverride = firestore,
        _forceMockMode = forceMockMode,
        _mockTerritories = List<Territory>.unmodifiable(
          initialMockTerritories ?? SeedData.buildSeedTerritories(),
        );

  static const String territoriesCollection = 'territories';
  static const String submissionsCollection = 'territory_submissions';

  final FirebaseFirestore? _firestoreOverride;
  final bool? _forceMockMode;
  final List<Territory> _mockTerritories;
  final List<TerritorySubmission> _localSubmissions = <TerritorySubmission>[];

  /// In-memory moderation queue mirror for offline/mock verification.
  List<TerritorySubmission> get localSubmissions =>
      List<TerritorySubmission>.unmodifiable(_localSubmissions);

  bool get _useFirestore {
    if (_forceMockMode == true) return false;
    if (_firestoreOverride != null && !AppEnv.useMockData) return true;
    return !AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady;
  }

  FirebaseFirestore get _firestore =>
      _firestoreOverride ?? FirebaseFirestore.instance;

  @override
  Future<List<Territory>> fetchTerritories({
    String? citySlug,
    String? stateCode,
    int limit = 50,
  }) async {
    if (_useFirestore) {
      try {
        Query<Map<String, dynamic>> query =
            _firestore.collection(territoriesCollection);
        if (citySlug != null && citySlug.isNotEmpty) {
          query = query.where('citySlug', isEqualTo: citySlug.toLowerCase());
        }
        if (stateCode != null && stateCode.isNotEmpty) {
          query = query.where('stateCode', isEqualTo: stateCode.toUpperCase());
        }
        final snapshot = await query.limit(limit).get();
        return snapshot.docs
            .map(_territoryFromSnapshot)
            .whereType<Territory>()
            .toList();
      } catch (_) {
        // Fall back to deterministic seeded territories if Firestore fails.
      }
    }

    return _mockTerritories.where((Territory territory) {
      final matchesCity = citySlug == null ||
          citySlug.isEmpty ||
          territory.citySlug.toLowerCase() == citySlug.toLowerCase();
      final matchesState = stateCode == null ||
          stateCode.isEmpty ||
          territory.stateCode.toUpperCase() == stateCode.toUpperCase();
      return matchesCity && matchesState;
    }).take(limit).toList();
  }

  @override
  Future<void> submitCorrection(TerritorySubmission submission) async {
    final moderatedSubmission = submission.copyWith(
      moderationStatus: 'pending_review',
    );
    _localSubmissions.add(moderatedSubmission);

    if (_useFirestore) {
      final authUid = FirebaseAuth.instance.currentUser?.uid;
      final effectiveUserId = (authUid != null && authUid.isNotEmpty)
          ? authUid
          : moderatedSubmission.submittedByUserId;

      await _firestore
          .collection(submissionsCollection)
          .doc(moderatedSubmission.id)
          .set(<String, dynamic>{
        'id': moderatedSubmission.id,
        'territoryId': moderatedSubmission.territoryId,
        'proposedName': moderatedSubmission.proposedName,
        'citySlug': moderatedSubmission.citySlug,
        'stateCode': moderatedSubmission.stateCode,
        'sourceCitation': moderatedSubmission.sourceCitation,
        'notes': moderatedSubmission.notes,
        'submittedByUserId': effectiveUserId,
        'submittedAt': Timestamp.fromDate(
          moderatedSubmission.submittedAt.toUtc(),
        ),
        'moderationStatus': 'pending_review',
      });
    }
  }

  Territory? _territoryFromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) return null;

    try {
      final rawPoints = data['polygonPoints'];
      final points = <TerritoryVertex>[];
      if (rawPoints is List<dynamic>) {
        for (final item in rawPoints) {
          if (item is GeoPoint) {
            points.add(
              TerritoryVertex(
                latitude: item.latitude,
                longitude: item.longitude,
              ),
            );
          } else if (item is Map<String, dynamic>) {
            final lat = item['latitude'];
            final lng = item['longitude'];
            if (lat is num && lng is num) {
              points.add(
                TerritoryVertex(
                  latitude: lat.toDouble(),
                  longitude: lng.toDouble(),
                ),
              );
            }
          }
        }
      }

      if (points.length < 3) return null;

      final updatedAtRaw = data['updatedAt'];
      DateTime updatedAt = DateTime.now().toUtc();
      if (updatedAtRaw is Timestamp) {
        updatedAt = updatedAtRaw.toDate().toUtc();
      } else if (updatedAtRaw is String) {
        updatedAt = DateTime.tryParse(updatedAtRaw)?.toUtc() ?? updatedAt;
      }

      return Territory(
        id: doc.id,
        name: _asString(data['name'], fallback: 'Historical Sector'),
        citySlug: _asString(data['citySlug'], fallback: 'atlanta'),
        stateCode: _asString(data['stateCode'], fallback: 'GA'),
        colorHex: _asString(data['colorHex'], fallback: '#F59E0B'),
        polygonPoints: points,
        citationDate: _asString(data['citationDate'], fallback: '2024-01-01'),
        sourceReference: _asString(
          data['sourceReference'],
          fallback: 'Public Historical Municipal Archive',
        ),
        contextLabel: ComplianceConstants.historicalTerritoryLabel,
        historicalNotes: data['historicalNotes'] is String
            ? data['historicalNotes'] as String
            : null,
        updatedAt: updatedAt,
      );
    } catch (_) {
      return null;
    }
  }

  String _asString(Object? value, {required String fallback}) {
    if (value is String && value.isNotEmpty) return value;
    return fallback;
  }
}
