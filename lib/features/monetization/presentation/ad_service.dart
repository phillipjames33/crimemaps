import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/config/app_env.dart';
import '../../../core/theme/app_theme.dart';
import '../domain/subscription_tier.dart';
import 'monetization_controller.dart';
import 'paywall_screen.dart';

/// Helper service for initializing Google Mobile Ads safely.
class AdService {
  const AdService._();

  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    if (_initialized) return;
    if (!AppEnv.useMockData && AppEnv.admobBannerUnitId.isNotEmpty) {
      try {
        await MobileAds.instance.initialize();
        _initialized = true;
      } catch (_) {
        _initialized = false;
      }
    }
  }
}

/// Non-intrusive banner widget for Free-tier users.
///
/// Hides completely when `isPro == true`.
/// Safely renders a sleek, non-blocking mock sponsor bar in emulator/test
/// environments without crashing on missing native AdMob SDK.
class FreeTierAdBanner extends ConsumerStatefulWidget {
  final VoidCallback? onUpgradePressed;

  const FreeTierAdBanner({
    super.key,
    this.onUpgradePressed,
  });

  @override
  ConsumerState<FreeTierAdBanner> createState() => _FreeTierAdBannerState();
}

class _FreeTierAdBannerState extends ConsumerState<FreeTierAdBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadNativeAdIfAvailable();
  }

  void _loadNativeAdIfAvailable() {
    if (!AppEnv.useMockData &&
        AppEnv.admobBannerUnitId.isNotEmpty &&
        AdService.isInitialized) {
      try {
        _bannerAd = BannerAd(
          adUnitId: AppEnv.admobBannerUnitId,
          size: AdSize.banner,
          request: const AdRequest(),
          listener: BannerAdListener(
            onAdLoaded: (_) {
              if (mounted) setState(() => _isAdLoaded = true);
            },
            onAdFailedToLoad: (Ad ad, LoadAdError error) {
              ad.dispose();
              if (mounted) setState(() => _bannerAd = null);
            },
          ),
        )..load();
      } catch (_) {
        _bannerAd = null;
      }
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _openPaywall() {
    if (widget.onUpgradePressed != null) {
      widget.onUpgradePressed!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const PaywallScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<EntitlementState> stateAsync =
        ref.watch(monetizationControllerProvider);

    final bool isPro = stateAsync.valueOrNull?.isPro ?? false;
    if (isPro) {
      return const SizedBox.shrink();
    }

    if (_isAdLoaded && _bannerAd != null) {
      return Container(
        key: const Key('free_tier_native_ad_banner'),
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // Sleek non-blocking mock sponsor bar for Free-tier users
    return Container(
      key: const Key('free_tier_ad_banner'),
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.surfaceElevated,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppTheme.borderSubtle),
            ),
            child: const Text(
              'SPONSOR',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppTheme.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'Free Tier • Support indie artists or upgrade to Pro',
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            key: const Key('ad_banner_upgrade_button'),
            onTap: _openPaywall,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.accentCyan.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppTheme.accentCyan.withValues(alpha: 0.5)),
              ),
              child: const Text(
                'GO PRO',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentCyan,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
