import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/firebase_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

part 'auth_controller.g.dart';

class AuthUiState {
  const AuthUiState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.infoMessage,
  });

  final AppUser? user;
  final bool isLoading;
  final String? errorMessage;
  final String? infoMessage;

  bool get isAuthenticated => user != null;

  AuthUiState copyWith({
    AppUser? user,
    bool clearUser = false,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    String? infoMessage,
    bool clearInfo = false,
  }) {
    return AuthUiState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      infoMessage: clearInfo ? null : (infoMessage ?? this.infoMessage),
    );
  }
}

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  StreamSubscription<AppUser?>? _authSub;
  bool _disposed = false;

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  AuthUiState build() {
    _disposed = false;
    final repo = ref.watch(authRepositoryProvider);
    _authSub?.cancel();
    _authSub = repo.watchAuthState().listen((AppUser? user) {
      if (_disposed) return;
      state = state.copyWith(
        user: user,
        clearUser: user == null,
      );
    });
    ref.onDispose(() {
      _disposed = true;
      unawaited(_authSub?.cancel());
    });
    return AuthUiState(user: repo.currentUser);
  }

  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearInfo: true);
    try {
      final user = await _repository.signInWithEmail(
        email: email,
        password: password,
      );
      if (!_disposed) {
        state = state.copyWith(user: user, isLoading: false);
      }
      return true;
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      return false;
    }
  }

  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    bool isArtist = false,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearInfo: true);
    try {
      final user = await _repository.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
        isArtist: isArtist,
      );
      if (!_disposed) {
        state = state.copyWith(user: user, isLoading: false);
      }
      return true;
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      return false;
    }
  }

  Future<bool> signInWithProvider(AuthProviderType provider) async {
    state = state.copyWith(isLoading: true, clearError: true, clearInfo: true);
    try {
      final user = await _repository.signInWithProvider(provider);
      if (!_disposed) {
        state = state.copyWith(user: user, isLoading: false);
      }
      return true;
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      return false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, clearError: true, clearInfo: true);
    try {
      await _repository.sendPasswordReset(email);
      if (!_disposed) {
        state = state.copyWith(
          isLoading: false,
          infoMessage: 'Password reset instructions sent to ${email.trim()}.',
        );
      }
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, clearError: true, clearInfo: true);
    await _repository.signOut();
    if (!_disposed) {
      state = state.copyWith(clearUser: true, isLoading: false);
    }
  }

  Future<bool> deleteAccount() async {
    state = state.copyWith(isLoading: true, clearError: true, clearInfo: true);
    try {
      await _repository.deleteAccount();
      if (!_disposed) {
        state = state.copyWith(
          clearUser: true,
          isLoading: false,
          infoMessage: 'Your Crime Maps account and profile have been deleted.',
        );
      }
      return true;
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(isLoading: false, errorMessage: e.toString());
      }
      return false;
    }
  }
}
