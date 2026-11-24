import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/config/app_env.dart';
import '../../../core/services/firebase_bootstrap.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

part 'firebase_auth_repository.g.dart';

class AuthFailureException implements Exception {
  const AuthFailureException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Firebase Auth + `users/{uid}` Firestore profile implementation with
/// seamless local mock fallback for offline/emulator runs.
class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository() {
    if (_useLiveFirebase) {
      _firebaseSub = fb.FirebaseAuth.instance.authStateChanges().listen(
        (fb.User? user) {
          _currentUser = user == null ? null : _mapFirebaseUser(user);
          if (!_controller.isClosed) {
            _controller.add(_currentUser);
          }
        },
      );
      final existing = fb.FirebaseAuth.instance.currentUser;
      _currentUser = existing == null ? null : _mapFirebaseUser(existing);
    }
  }

  static const Uuid _uuid = Uuid();

  final StreamController<AppUser?> _controller =
      StreamController<AppUser?>.broadcast();
  StreamSubscription<fb.User?>? _firebaseSub;
  AppUser? _currentUser;

  bool get _useLiveFirebase =>
      !AppEnv.useMockData && FirebaseBootstrap.isFirebaseReady;

  void dispose() {
    unawaited(_firebaseSub?.cancel());
    unawaited(_controller.close());
  }

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> watchAuthState() async* {
    yield _currentUser;
    yield* _controller.stream;
  }

  @override
  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();
    if (!trimmedEmail.contains('@') || trimmedEmail.length < 5) {
      throw const AuthFailureException('Enter a valid email address.');
    }
    if (password.length < 6) {
      throw const AuthFailureException(
        'Password must be at least 6 characters.',
      );
    }

    if (_useLiveFirebase) {
      try {
        final cred = await fb.FirebaseAuth.instance.signInWithEmailAndPassword(
          email: trimmedEmail,
          password: password,
        );
        final fbUser = cred.user;
        if (fbUser == null) {
          throw const AuthFailureException('Sign-in returned no user profile.');
        }
        final mapped = _mapFirebaseUser(fbUser);
        await _syncUserDocument(mapped);
        _emitUser(mapped);
        return mapped;
      } on fb.FirebaseAuthException catch (e) {
        throw AuthFailureException(e.message ?? 'Authentication failed.');
      }
    }

    final fallbackName = trimmedEmail.split('@').first;
    final demoUser = AppUser(
      uid: 'usr-${_uuid.v4().substring(0, 8)}',
      email: trimmedEmail,
      displayName: _titleCase(fallbackName),
      provider: AuthProviderType.email,
      createdAt: DateTime.now().toUtc(),
    );
    _emitUser(demoUser);
    return demoUser;
  }

  @override
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    bool isArtist = false,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();
    final trimmedName = displayName.trim();
    if (trimmedName.length < 2) {
      throw const AuthFailureException('Enter your display name.');
    }
    if (!trimmedEmail.contains('@') || trimmedEmail.length < 5) {
      throw const AuthFailureException('Enter a valid email address.');
    }
    if (password.length < 6) {
      throw const AuthFailureException(
        'Password must be at least 6 characters.',
      );
    }

    if (_useLiveFirebase) {
      try {
        final cred =
            await fb.FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: trimmedEmail,
          password: password,
        );
        final fbUser = cred.user;
        if (fbUser == null) {
          throw const AuthFailureException('Account creation failed.');
        }
        await fbUser.updateDisplayName(trimmedName);
        final mapped = AppUser(
          uid: fbUser.uid,
          email: trimmedEmail,
          displayName: trimmedName,
          isArtist: isArtist,
          provider: AuthProviderType.email,
          createdAt: DateTime.now().toUtc(),
        );
        await _syncUserDocument(mapped);
        _emitUser(mapped);
        return mapped;
      } on fb.FirebaseAuthException catch (e) {
        throw AuthFailureException(e.message ?? 'Account creation failed.');
      }
    }

    final created = AppUser(
      uid: 'usr-${_uuid.v4().substring(0, 8)}',
      email: trimmedEmail,
      displayName: trimmedName,
      isArtist: isArtist,
      provider: AuthProviderType.email,
      createdAt: DateTime.now().toUtc(),
    );
    _emitUser(created);
    return created;
  }

  @override
  Future<AppUser> signInWithProvider(AuthProviderType provider) async {
    if (_useLiveFirebase) {
      try {
        final fb.AuthProvider authProvider = switch (provider) {
          AuthProviderType.google => fb.GoogleAuthProvider(),
          AuthProviderType.apple => fb.AppleAuthProvider(),
          AuthProviderType.email || AuthProviderType.demo =>
            fb.GoogleAuthProvider(),
        };
        final cred =
            await fb.FirebaseAuth.instance.signInWithProvider(authProvider);
        final fbUser = cred.user;
        if (fbUser == null) {
          throw const AuthFailureException('Provider sign-in cancelled.');
        }
        final mapped = _mapFirebaseUser(fbUser, overrideProvider: provider);
        await _syncUserDocument(mapped);
        _emitUser(mapped);
        return mapped;
      } on fb.FirebaseAuthException catch (e) {
        throw AuthFailureException(e.message ?? 'Provider sign-in failed.');
      }
    }

    final label = provider == AuthProviderType.apple ? 'Apple' : 'Google';
    final demoUser = AppUser(
      uid: 'usr-${provider.name}-${_uuid.v4().substring(0, 6)}',
      email: '${provider.name}.user@crimemaps.local',
      displayName: 'Crime Maps $label User',
      isArtist: true,
      provider: provider,
      createdAt: DateTime.now().toUtc(),
    );
    _emitUser(demoUser);
    return demoUser;
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    final trimmed = email.trim().toLowerCase();
    if (!trimmed.contains('@')) {
      throw const AuthFailureException('Enter a valid email address first.');
    }
    if (_useLiveFirebase) {
      try {
        await fb.FirebaseAuth.instance.sendPasswordResetEmail(email: trimmed);
      } on fb.FirebaseAuthException catch (e) {
        throw AuthFailureException(e.message ?? 'Password reset failed.');
      }
    }
  }

  @override
  Future<void> signOut() async {
    if (_useLiveFirebase) {
      await fb.FirebaseAuth.instance.signOut();
    }
    _emitUser(null);
  }

  void _emitUser(AppUser? user) {
    _currentUser = user;
    if (!_controller.isClosed) {
      _controller.add(user);
    }
  }

  AppUser _mapFirebaseUser(
    fb.User user, {
    AuthProviderType? overrideProvider,
  }) {
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: (user.displayName != null && user.displayName!.isNotEmpty)
          ? user.displayName!
          : (user.email?.split('@').first ?? 'Crime Maps User'),
      provider: overrideProvider ?? AuthProviderType.email,
      createdAt: user.metadata.creationTime?.toUtc(),
    );
  }

  Future<void> _syncUserDocument(AppUser user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        <String, dynamic>{
          'displayName': user.displayName,
          'email': user.email,
          'isArtist': user.isArtist,
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (_) {
      // Non-fatal if Firestore offline.
    }
  }

  static String _titleCase(String input) {
    if (input.isEmpty) return 'Crime Maps User';
    return input
        .split(RegExp(r'[._\-\s]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final repo = FirebaseAuthRepository();
  ref.onDispose(repo.dispose);
  return repo;
}
