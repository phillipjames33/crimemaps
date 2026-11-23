import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/config/compliance_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/incident_model.dart';

/// Displays public county booking details with mandatory legal protections:
/// - Always renders the visible Presumed Innocent disclaimer
/// - Displays the automatic 45-day TTL expiry window
/// - Provides a 100% FREE "Request Record Removal / Expungement" action
/// - Replaces personal details with a clear notice when [AllegedOffender.redacted] is true
class AllegedOffenderCard extends StatelessWidget {
  const AllegedOffenderCard({
    super.key,
    required this.offender,
    this.onRequestRemoval,
  });

  final AllegedOffender offender;
  final VoidCallback? onRequestRemoval;

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('MMM d, yyyy • h:mm a');
    final expiryFormatter = DateFormat('MMM d, yyyy');
    final effectiveDisclaimer = offender.disclaimer.isNotEmpty
        ? offender.disclaimer
        : ComplianceConstants.presumedInnocentDisclaimer;
    final daysRemaining = offender.expiresAt
        .toUtc()
        .difference(DateTime.now().toUtc())
        .inDays
        .clamp(0, ComplianceConstants.bookingTtlDays);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(
                Icons.gavel_rounded,
                size: 18,
                color: AppTheme.accentAmber,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Public Arrest / Booking Record',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentCyan.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.accentCyan.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  '${ComplianceConstants.bookingTtlDays}-Day TTL • Exp ${expiryFormatter.format(offender.expiresAt.toLocal())}',
                  style: const TextStyle(
                    color: AppTheme.accentCyan,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // MANDATORY visible Presumed Innocent disclaimer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.accentAmber.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.accentAmber.withValues(alpha: 0.45),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppTheme.accentAmber,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    effectiveDisclaimer,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          if (offender.redacted) ...<Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.accentEmerald.withValues(alpha: 0.45),
                ),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    Icons.verified_user_outlined,
                    size: 20,
                    color: AppTheme.accentEmerald,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Booking Record Redacted',
                          style: TextStyle(
                            color: AppTheme.accentEmerald,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Name, photo, and charge details have been redacted pending free expungement or removal verification.',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ] else ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _BookingPhotoAvatar(photoUrl: offender.bookingPhotoUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        offender.name,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Booked: ${dateFormatter.format(offender.bookingDate.toLocal())}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Source: ${offender.sourceAgency}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Auto-deletes in $daysRemaining days (${ComplianceConstants.bookingTtlDays}-day automatic expiry)',
                        style: const TextStyle(
                          color: AppTheme.accentCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (offender.charges.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
              const Text(
                'Alleged Charge Summary',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 6),
              ...offender.charges.map(
                (String charge) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: AppTheme.accentAmber,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          charge,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 12.5,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onRequestRemoval,
                icon: const Icon(Icons.remove_circle_outline_rounded, size: 18),
                label: const Text('Request Record Removal / Expungement'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.accentEmerald,
                  side: BorderSide(
                    color: AppTheme.accentEmerald.withValues(alpha: 0.6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Center(
              child: Text(
                '100% Free — Never paywalled. Expunged or dismissed records removed promptly.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BookingPhotoAvatar extends StatelessWidget {
  const _BookingPhotoAvatar({this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final hasUrl = photoUrl != null && photoUrl!.trim().isNotEmpty;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 68,
        height: 82,
        color: AppTheme.surfaceDark,
        child: hasUrl
            ? CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                placeholder: (BuildContext context, String url) =>
                    const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget:
                    (BuildContext context, String url, Object error) =>
                        const _FallbackBookingAvatar(),
              )
            : const _FallbackBookingAvatar(),
      ),
    );
  }
}

class _FallbackBookingAvatar extends StatelessWidget {
  const _FallbackBookingAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border.all(color: AppTheme.borderSubtle),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.person_outline_rounded,
            size: 30,
            color: AppTheme.textSecondary,
          ),
          SizedBox(height: 4),
          Text(
            'No Photo',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 9.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
