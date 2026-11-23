import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../geo_radio/domain/track_model.dart';
import '../data/revenuecat_monetization_repository.dart';
import '../domain/subscription_tier.dart';
import 'monetization_controller.dart';

/// Modal bottom sheet allowing indie artists to boost their track to the top
/// of the Geo-Radio stream for a selected city or ZIP code.
class ArtistBoostSheet extends ConsumerStatefulWidget {
  final IndieTrack track;
  final void Function(String trackId, String targetZip, DateTime boostedUntil)?
      onBoostPurchased;

  const ArtistBoostSheet({
    super.key,
    required this.track,
    this.onBoostPurchased,
  });

  @override
  ConsumerState<ArtistBoostSheet> createState() => _ArtistBoostSheetState();
}

class _ArtistBoostSheetState extends ConsumerState<ArtistBoostSheet> {
  late final TextEditingController _zipController;
  late final TextEditingController _cityController;

  ArtistBoostPackage? _selectedPackage;
  bool _isPurchasing = false;

  @override
  void initState() {
    super.initState();
    _zipController = TextEditingController(text: widget.track.zipCode);
    _cityController = TextEditingController(text: widget.track.cityName);
  }

  @override
  void dispose() {
    _zipController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _handlePurchase(List<ArtistBoostPackage> packages) async {
    final ArtistBoostPackage package = _selectedPackage ?? packages.first;
    final String targetZip = _zipController.text.trim().isEmpty
        ? widget.track.zipCode
        : _zipController.text.trim();

    setState(() => _isPurchasing = true);

    try {
      final DateTime boostedUntil = await ref
          .read(monetizationControllerProvider.notifier)
          .purchaseArtistBoost(
            trackId: widget.track.id,
            targetZip: targetZip,
            package: package,
          );

      if (mounted) {
        widget.onBoostPurchased?.call(widget.track.id, targetZip, boostedUntil);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.accentEmerald,
            content: Text(
              'Boost active! "${widget.track.title}" is now #1 in ZIP $targetZip until ${boostedUntil.toLocal().toString().split('.').first}.',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.accentCrimson,
            content: Text('Failed to purchase boost: $e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPurchasing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArtistBoostPackage>>(
      future: ref.read(monetizationRepositoryProvider).fetchBoostPackages(),
      builder: (BuildContext context, AsyncSnapshot<List<ArtistBoostPackage>> snapshot) {
        final List<ArtistBoostPackage> packages =
            snapshot.data ?? const <ArtistBoostPackage>[];
        final ArtistBoostPackage currentSelection =
            _selectedPackage ?? (packages.isNotEmpty ? packages.first : _fallbackPackage);

        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Handle indicator
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

                // Title row
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.accentAmber.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.rocket_launch,
                          color: AppTheme.accentAmber, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Boost Track on Geo-Radio',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            'Surface "${widget.track.title}" to local drivers',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: AppTheme.borderSubtle),

                // Target Location Inputs
                const Text(
                  'Target Broadcast Zone',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentCyan,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: TextField(
                        key: const Key('boost_city_field'),
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: 'Target City',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        key: const Key('boost_zip_field'),
                        controller: _zipController,
                        decoration: const InputDecoration(
                          labelText: 'Target ZIP Code',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Boost Package Options
                const Text(
                  'Select Priority Tier',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accentCyan,
                  ),
                ),
                const SizedBox(height: 8),
                if (packages.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else
                  ...packages.map((ArtistBoostPackage pkg) {
                    final bool isSelected = currentSelection.productId == pkg.productId;
                    return Container(
                      key: Key('boost_package_${pkg.productId}'),
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.accentAmber.withValues(alpha: 0.12)
                            : AppTheme.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.accentAmber
                              : AppTheme.borderSubtle,
                          width: isSelected ? 1.5 : 1.0,
                        ),
                      ),
                      child: ListTile(
                        onTap: () => setState(() => _selectedPackage = pkg),
                        leading: Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? AppTheme.accentAmber : AppTheme.textSecondary,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              pkg.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isSelected
                                    ? AppTheme.accentAmber
                                    : AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              pkg.priceDisplay,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          pkg.description,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 16),

                // Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    key: const Key('confirm_boost_button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentAmber,
                      foregroundColor: const Color(0xFF1A1100),
                    ),
                    onPressed: _isPurchasing ? null : () => _handlePurchase(packages),
                    child: _isPurchasing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF1A1100),
                            ),
                          )
                        : Text(
                            'Activate Boost • ${currentSelection.priceDisplay}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static const ArtistBoostPackage _fallbackPackage = ArtistBoostPackage(
    productId: 'boost_24h_zip',
    label: '24h ZIP Boost',
    durationHours: 24,
    priceDisplay: '\$9.99',
    description: 'Pin your indie track at #1 in target ZIP radio queue for 24 hours.',
  );
}
