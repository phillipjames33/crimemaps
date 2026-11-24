import 'auth_user.dart';

/// Pure-Dart authentication repository contract.
/// Map browsing and 100% free record removal work without signing in;
/// authentication is used for Creator uploads, community camera/territory
/// submissions, and syncing user geofences/entitlements.
abstract class AuthRepository {
  Stream<AppUser?> watchAuthState();

  AppUser? get currentUser;

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  });

  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    bool isArtist = false,
  });

  Future<AppUser> signInWithProvider(AuthProviderType provider);

  Future<void> sendPasswordReset(String email);

  Future<void> signOut();
}
