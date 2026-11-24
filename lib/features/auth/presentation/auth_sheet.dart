import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../domain/auth_user.dart';
import 'auth_controller.dart';

/// Opens the Crime Maps Sign-In / Create Account / Profile bottom sheet.
Future<void> showAuthSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.surfaceDark,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext sheetContext) {
      return const AuthSheet();
    },
  );
}

/// Compact reusable account pill button for AppBars (Creator, Pro, Radar).
class AccountActionChip extends ConsumerWidget {
  const AccountActionChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(
      authControllerProvider.select((AuthUiState s) => s.user),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ActionChip(
        key: const Key('account_action_chip'),
        avatar: Icon(
          user == null ? Icons.login_rounded : Icons.verified_user_rounded,
          size: 16,
          color: user == null ? AppTheme.accentCyan : AppTheme.accentEmerald,
        ),
        label: Text(
          user == null ? 'Sign In' : user.displayName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.surfaceElevated,
        side: BorderSide(
          color: user == null ? AppTheme.borderSubtle : AppTheme.accentEmerald,
        ),
        onPressed: () => unawaited(showAuthSheet(context)),
      ),
    );
  }
}

/// Interactive Sign-In / Create Account / Profile modal sheet.
class AuthSheet extends ConsumerStatefulWidget {
  const AuthSheet({super.key});

  @override
  ConsumerState<AuthSheet> createState() => _AuthSheetState();
}

class _AuthSheetState extends ConsumerState<AuthSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSignUpMode = false;
  bool _isArtistAccount = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmailAuth() async {
    final notifier = ref.read(authControllerProvider.notifier);
    final bool ok;
    if (_isSignUpMode) {
      ok = await notifier.signUpWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        displayName: _nameController.text,
        isArtist: _isArtistAccount,
      );
    } else {
      ok = await notifier.signInWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
    if (ok && mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _submitProvider(AuthProviderType provider) async {
    final ok = await ref
        .read(authControllerProvider.notifier)
        .signInWithProvider(provider);
    if (ok && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: user != null
            ? _SignedInProfileView(
                user: user,
                isLoading: authState.isLoading,
                onSignOut: () async {
                  await ref.read(authControllerProvider.notifier).signOut();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.shield_outlined,
                        color: AppTheme.accentCyan,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _isSignUpMode
                              ? 'Create Crime Maps Account'
                              : 'Sign In to Crime Maps',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Browsing the crime map and submitting 100% free record removal requests never require an account. Sign in to upload indie tracks, submit civic camera/territory updates, or sync Pro geofences.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (authState.errorMessage != null) ...<Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentCrimson.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.accentCrimson),
                      ),
                      child: Text(
                        authState.errorMessage!,
                        style: const TextStyle(
                          color: AppTheme.accentCrimson,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (authState.infoMessage != null) ...<Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.accentEmerald.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.accentEmerald),
                      ),
                      child: Text(
                        authState.infoMessage!,
                        style: const TextStyle(
                          color: AppTheme.accentEmerald,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_isSignUpMode) ...<Widget>[
                    TextField(
                      key: const Key('auth_name_field'),
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Display Name / Artist Name',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  TextField(
                    key: const Key('auth_email_field'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    key: const Key('auth_password_field'),
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password (min 6 chars)',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                  if (_isSignUpMode) ...<Widget>[
                    const SizedBox(height: 6),
                    CheckboxListTile(
                      key: const Key('auth_artist_checkbox'),
                      contentPadding: EdgeInsets.zero,
                      value: _isArtistAccount,
                      onChanged: (bool? v) {
                        setState(() => _isArtistAccount = v ?? false);
                      },
                      title: const Text(
                        'Register as an Independent Music Artist',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  ElevatedButton(
                    key: const Key('auth_submit_button'),
                    onPressed: authState.isLoading
                        ? null
                        : () => unawaited(_submitEmailAuth()),
                    child: authState.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_isSignUpMode ? 'Create Account' : 'Sign In'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const Key('auth_google_button'),
                          onPressed: authState.isLoading
                              ? null
                              : () => unawaited(
                                    _submitProvider(AuthProviderType.google),
                                  ),
                          icon: const Icon(Icons.g_mobiledata_rounded),
                          label: const Text('Google'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const Key('auth_apple_button'),
                          onPressed: authState.isLoading
                              ? null
                              : () => unawaited(
                                    _submitProvider(AuthProviderType.apple),
                                  ),
                          icon: const Icon(Icons.apple_rounded),
                          label: const Text('Apple'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextButton(
                        key: const Key('auth_toggle_mode_button'),
                        onPressed: () {
                          setState(() => _isSignUpMode = !_isSignUpMode);
                        },
                        child: Text(
                          _isSignUpMode
                              ? 'Already have an account? Sign In'
                              : 'Need an account? Sign Up',
                        ),
                      ),
                      if (!_isSignUpMode)
                        TextButton(
                          onPressed: () {
                            unawaited(
                              ref
                                  .read(authControllerProvider.notifier)
                                  .sendPasswordReset(_emailController.text),
                            );
                          },
                          child: const Text('Reset Password'),
                        ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

class _SignedInProfileView extends StatelessWidget {
  const _SignedInProfileView({
    required this.user,
    required this.isLoading,
    required this.onSignOut,
  });

  final AppUser user;
  final bool isLoading;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: AppTheme.accentCyan.withValues(alpha: 0.2),
              child: const Icon(
                Icons.verified_user_rounded,
                color: AppTheme.accentCyan,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    user.displayName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (user.isArtist)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentPurple),
                ),
                child: const Text(
                  'INDIE ARTIST',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.accentPurple,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          key: const Key('auth_signout_button'),
          onPressed: isLoading ? null : onSignOut,
          icon: const Icon(Icons.logout_rounded, color: AppTheme.accentCrimson),
          label: const Text(
            'Sign Out',
            style: TextStyle(color: AppTheme.accentCrimson),
          ),
        ),
      ],
    );
  }
}
