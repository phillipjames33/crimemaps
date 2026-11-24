import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/config/compliance_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_sheet.dart';
import '../domain/subscription_tier.dart';
import 'monetization_controller.dart';

/// Crime Maps Pro Upgrade and Geofence Push Management Screen.
class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  SubscriptionPlan _selectedPlan = SubscriptionPlan.proAnnual;

  // Controllers for adding custom geofence
  final TextEditingController _geofenceLabelController =
      TextEditingController();
  final TextEditingController _latController =
      TextEditingController(text: '33.7749');
  final TextEditingController _lngController =
      TextEditingController(text: '-84.3964');
  final TextEditingController _radiusController =
      TextEditingController(text: '1200');
  final TextEditingController _geohashController =
      TextEditingController(text: 'dnh1');

  @override
  void dispose() {
    _geofenceLabelController.dispose();
    _latController.dispose();
    _lngController.dispose();
    _radiusController.dispose();
    _geohashController.dispose();
    super.dispose();
  }

  void _showAddGeofenceDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          title: const Row(
            children: <Widget>[
              Icon(Icons.add_location_alt, color: AppTheme.accentCyan),
              SizedBox(width: 8),
              Text('Add Alert Geofence', style: TextStyle(fontSize: 16)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  key: const Key('geofence_label_field'),
                  controller: _geofenceLabelController,
                  decoration: const InputDecoration(
                    labelText: 'Label (e.g., Home, Kids School)',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        key: const Key('geofence_lat_field'),
                        controller: _latController,
                        decoration:
                            const InputDecoration(labelText: 'Latitude'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        key: const Key('geofence_lng_field'),
                        controller: _lngController,
                        decoration:
                            const InputDecoration(labelText: 'Longitude'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        key: const Key('geofence_radius_field'),
                        controller: _radiusController,
                        decoration:
                            const InputDecoration(labelText: 'Radius (m)'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        key: const Key('geofence_geohash_field'),
                        controller: _geohashController,
                        decoration:
                            const InputDecoration(labelText: 'Geohash'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              key: const Key('geofence_save_button'),
              onPressed: () {
                final String label = _geofenceLabelController.text.trim();
                if (label.isEmpty) return;

                final double lat =
                    double.tryParse(_latController.text.trim()) ?? 33.7749;
                final double lng =
                    double.tryParse(_lngController.text.trim()) ?? -84.3964;
                final double radius =
                    double.tryParse(_radiusController.text.trim()) ?? 1200;
                final String geohash = _geohashController.text.trim().isEmpty
                    ? 'dnh1'
                    : _geohashController.text.trim();

                final SavedGeofence fence = SavedGeofence(
                  id: 'geo-${DateTime.now().millisecondsSinceEpoch}',
                  label: label,
                  latitude: lat,
                  longitude: lng,
                  radiusMeters: radius,
                  geohashPrefix: geohash,
                  alertsEnabled: true,
                );

                ref
                    .read(monetizationControllerProvider.notifier)
                    .addGeofence(fence);

                _geofenceLabelController.clear();
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Save & Subscribe'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<EntitlementState> stateAsync =
        ref.watch(monetizationControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('Crime Maps Pro'),
        actions: <Widget>[
          TextButton(
            key: const Key('paywall_restore_button'),
            onPressed: () async {
              await ref
                  .read(monetizationControllerProvider.notifier)
                  .restorePurchases();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Purchases restored successfully')),
                );
              }
            },
            child: const Text(
              'Restore',
              style: TextStyle(color: AppTheme.accentCyan),
            ),
          ),
          const AccountActionChip(),
        ],
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object err, StackTrace st) => Center(
          child: Text('Error loading subscription: $err',
              style: const TextStyle(color: AppTheme.accentCrimson)),
        ),
        data: (EntitlementState state) {
          final bool isPro = state.isPro;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeroBanner(isPro, state),
                const SizedBox(height: 20),
                _buildComparisonCard(),
                const SizedBox(height: 20),
                if (!isPro) ...<Widget>[
                  _buildPricingPlans(),
                  const SizedBox(height: 20),
                  _buildUpgradeButton(),
                  const SizedBox(height: 24),
                ],
                _buildCustomGeofenceSection(state),
                const SizedBox(height: 24),
                _buildSubscriptionLegalFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroBanner(bool isPro, EntitlementState state) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPro
              ? <Color>[
                  AppTheme.accentEmerald.withValues(alpha: 0.2),
                  AppTheme.surfaceElevated,
                ]
              : <Color>[
                  AppTheme.accentCyan.withValues(alpha: 0.15),
                  AppTheme.surfaceElevated,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPro ? AppTheme.accentEmerald : AppTheme.accentCyan,
          width: 1.5,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isPro
                  ? AppTheme.accentEmerald.withValues(alpha: 0.2)
                  : AppTheme.accentCyan.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPro ? Icons.verified : Icons.security,
              color: isPro ? AppTheme.accentEmerald : AppTheme.accentCyan,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      isPro ? 'Crime Maps Pro Active' : 'Upgrade to Pro',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isPro
                            ? AppTheme.accentEmerald
                            : AppTheme.accentAmber,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isPro ? 'PRO' : 'FREE TIER',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  isPro
                      ? 'All historical heatmaps, geofences, and ad-free Geo-Radio unlocked.'
                      : 'Real-time situational intelligence and unlimited custom geofence alerts.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard() {
    return Card(
      color: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Feature Comparison',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const Divider(height: 20, color: AppTheme.borderSubtle),
            _buildComparisonRow(
              feature: 'Historical Crime Heatmaps',
              freeTier: '24h Recent Only',
              proTier: 'Statewide Archive (365d)',
            ),
            _buildComparisonRow(
              feature: 'Custom Geofence Alerts',
              freeTier: '2 Default Zones',
              proTier: 'Unlimited Custom Polygons',
            ),
            _buildComparisonRow(
              feature: 'Civic Camera Radar',
              freeTier: 'Live Map View',
              proTier: 'Offline High-Speed Cache',
            ),
            _buildComparisonRow(
              feature: 'Indie Geo-Radio',
              freeTier: 'Free + Sponsor Bar',
              proTier: '100% Ad-Free Audio Stream',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow({
    required String feature,
    required String freeTier,
    required String proTier,
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              feature,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              freeTier,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: <Widget>[
                const Icon(Icons.check_circle,
                    size: 14, color: AppTheme.accentCyan),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    proTier,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentCyan,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingPlans() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Select Membership',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: _buildPlanSelector(
                key: const Key('plan_annual_card'),
                plan: SubscriptionPlan.proAnnual,
                title: 'Pro Annual',
                price: '\$49.99 / yr',
                badge: 'SAVE 40%',
                subtitle: 'Equivalent to \$4.16/mo',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPlanSelector(
                key: const Key('plan_monthly_card'),
                plan: SubscriptionPlan.proMonthly,
                title: 'Pro Monthly',
                price: '\$6.99 / mo',
                badge: null,
                subtitle: 'Flexible month-to-month',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanSelector({
    required Key key,
    required SubscriptionPlan plan,
    required String title,
    required String price,
    required String? badge,
    required String subtitle,
  }) {
    final bool isSelected = _selectedPlan == plan;

    return InkWell(
      key: key,
      onTap: () => setState(() => _selectedPlan = plan),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.accentCyan.withValues(alpha: 0.12)
              : AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppTheme.accentCyan : AppTheme.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentAmber,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? AppTheme.accentCyan : AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        key: const Key('paywall_upgrade_button'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.accentCyan,
          foregroundColor: const Color(0xFF06131F),
        ),
        onPressed: () async {
          await ref
              .read(monetizationControllerProvider.notifier)
              .upgradeToPro(_selectedPlan);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppTheme.accentEmerald,
                content: Text(
                  _selectedPlan == SubscriptionPlan.proAnnual
                      ? 'Upgraded to Crime Maps Pro Annual!'
                      : 'Upgraded to Crime Maps Pro Monthly!',
                ),
              ),
            );
          }
        },
        child: Text(
          _selectedPlan == SubscriptionPlan.proAnnual
              ? 'Upgrade Now • \$49.99 / Year'
              : 'Upgrade Now • \$6.99 / Month',
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCustomGeofenceSection(EntitlementState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Row(
              children: <Widget>[
                Icon(Icons.radar, color: AppTheme.accentAmber, size: 20),
                SizedBox(width: 8),
                Text(
                  'Custom Geofences & FCM Alert Zones',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            IconButton(
              key: const Key('add_geofence_button'),
              icon: const Icon(Icons.add_circle, color: AppTheme.accentCyan),
              onPressed: _showAddGeofenceDialog,
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage your personal safety perimeters and subscribed push alert channels.',
          style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 12),

        // Subscribed Topics Chips
        const Text(
          'Active FCM Alert Subscriptions:',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: state.subscribedFcmTopics.map((String topic) {
            return Chip(
              key: Key('fcm_chip_$topic'),
              backgroundColor: AppTheme.surfaceElevated,
              side: const BorderSide(color: AppTheme.borderSubtle),
              label: Text(
                topic,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.accentCyan,
                  fontWeight: FontWeight.w600,
                ),
              ),
              deleteIcon: const Icon(Icons.close, size: 14),
              onDeleted: () {
                ref
                    .read(monetizationControllerProvider.notifier)
                    .toggleFcmTopic(topic, false);
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Geofences List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.savedGeofences.length,
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 8),
          itemBuilder: (BuildContext context, int index) {
            final SavedGeofence fence = state.savedGeofences[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.location_pin,
                      color: AppTheme.accentAmber, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          fence.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          '${fence.latitude.toStringAsFixed(4)}, ${fence.longitude.toStringAsFixed(4)} • Radius: ${fence.radiusMeters.toInt()}m • Topic: geo_${fence.geohashPrefix}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    key: Key('delete_geofence_${fence.id}'),
                    icon: const Icon(Icons.delete_outline,
                        color: AppTheme.accentCrimson, size: 18),
                    onPressed: () {
                      ref
                          .read(monetizationControllerProvider.notifier)
                          .removeGeofence(fence.id);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _openExternalLink(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Widget _buildSubscriptionLegalFooter() {
    return Container(
      key: const Key('paywall_legal_footer'),
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Subscriptions renew automatically unless canceled at least 24 hours '
            'before the end of the current period in your App Store or Google Play '
            'account settings. Record removal is always 100% free and never '
            'requires a Pro membership.',
            style: TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: <Widget>[
              TextButton(
                key: const Key('paywall_privacy_link'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () =>
                    _openExternalLink(ComplianceConstants.privacyPolicyUrl),
                child: const Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 12, color: AppTheme.accentCyan),
                ),
              ),
              TextButton(
                key: const Key('paywall_terms_link'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () =>
                    _openExternalLink(ComplianceConstants.termsOfServiceUrl),
                child: const Text(
                  'Terms of Service',
                  style: TextStyle(fontSize: 12, color: AppTheme.accentCyan),
                ),
              ),
              TextButton(
                key: const Key('paywall_removal_link'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () =>
                    _openExternalLink(ComplianceConstants.freeRemovalPortalUrl),
                child: const Text(
                  'Free Record Removal',
                  style: TextStyle(fontSize: 12, color: AppTheme.accentEmerald),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
