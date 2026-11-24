import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_env.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../map/presentation/widgets/street_view_3d_screen.dart';
import '../../domain/incident_model.dart';
import '../saved_incidents_controller.dart';
import 'alleged_offender_card.dart';

/// Draggable detail sheet showing an incident's exact street context,
/// Street View static thumbnail, 3D Photorealistic inspection launcher,
/// interactive Street View external link, and optional [AllegedOffenderCard].
class IncidentDetailSheet extends ConsumerWidget {
  const IncidentDetailSheet({
    super.key,
    required this.incident,
    this.onRequestRemoval,
    this.scrollController,
  });

  final Incident incident;
  final void Function(Incident incident)? onRequestRemoval;
  final ScrollController? scrollController;

  static Future<void> show(
    BuildContext context, {
    required Incident incident,
    void Function(Incident incident)? onRequestRemoval,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72,
          minChildSize: 0.42,
          maxChildSize: 0.94,
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(
                  top: BorderSide(color: AppTheme.borderSubtle),
                ),
              ),
              child: IncidentDetailSheet(
                incident: incident,
                onRequestRemoval: onRequestRemoval,
                scrollController: scrollController,
              ),
            );
          },
        );
      },
    );
  }

  Color _categoryColor(IncidentCategory category) {
    switch (category) {
      case IncidentCategory.violent:
        return AppTheme.accentCrimson;
      case IncidentCategory.property:
        return AppTheme.accentAmber;
      case IncidentCategory.trafficDui:
        return AppTheme.accentCyan;
      case IncidentCategory.other:
        return AppTheme.accentPurple;
    }
  }

  String _categoryLabel(IncidentCategory category) {
    switch (category) {
      case IncidentCategory.violent:
        return 'Violent Offense';
      case IncidentCategory.property:
        return 'Property Crime';
      case IncidentCategory.trafficDui:
        return 'Traffic / DUI';
      case IncidentCategory.other:
        return 'Public Safety';
    }
  }

  Color _severityColor(IncidentSeverity severity) {
    switch (severity) {
      case IncidentSeverity.critical:
        return AppTheme.accentCrimson;
      case IncidentSeverity.high:
        return const Color(0xFFF97316);
      case IncidentSeverity.medium:
        return AppTheme.accentAmber;
      case IncidentSeverity.low:
        return AppTheme.accentEmerald;
    }
  }

  String _formatPlaceType(String raw) {
    return raw
        .split('_')
        .where((String part) => part.isNotEmpty)
        .map((String part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  Future<void> _openExternalStreetView(BuildContext context) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/@?api=1&map_action=pano'
      '&viewpoint=${incident.geo.latitude},${incident.geo.longitude}',
    );
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to launch interactive Street View.'),
        ),
      );
    }
  }

  void _open3dInspection(BuildContext context) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext routeContext) => StreetView3dScreen(
            latitude: incident.geo.latitude,
            longitude: incident.geo.longitude,
            label: '${incident.placeName} • ${incident.address}',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryColor = _categoryColor(incident.category);
    final severityColor = _severityColor(incident.severity);
    final timeFormatter = DateFormat('EEE, MMM d, yyyy • h:mm a');
    final streetViewUrl = incident.streetViewUrl ??
        AppEnv.buildStreetViewUrl(
          latitude: incident.geo.latitude,
          longitude: incident.geo.longitude,
        );
    final isSaved = ref.watch(
      savedIncidentsControllerProvider.select(
        (Set<String> ids) => ids.contains(incident.id),
      ),
    );

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Category & Severity badges
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: <Widget>[
                _BadgePill(
                  label: _categoryLabel(incident.category),
                  color: categoryColor,
                  icon: Icons.shield_outlined,
                ),
                _BadgePill(
                  label: incident.severity.name.toUpperCase(),
                  color: severityColor,
                  icon: Icons.priority_high_rounded,
                ),
                _BadgePill(
                  label: '${incident.cityName}, ${incident.stateCode}',
                  color: AppTheme.textSecondary,
                  icon: Icons.location_city_rounded,
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    incident.title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  key: const Key('incident_bookmark_button'),
                  tooltip: isSaved ? 'Remove bookmark' : 'Save incident',
                  style: IconButton.styleFrom(
                    backgroundColor: isSaved
                        ? AppTheme.accentAmber.withValues(alpha: 0.16)
                        : AppTheme.surfaceElevated,
                    side: BorderSide(
                      color: isSaved
                          ? AppTheme.accentAmber.withValues(alpha: 0.6)
                          : AppTheme.borderSubtle,
                    ),
                  ),
                  icon: Icon(
                    isSaved
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    color:
                        isSaved ? AppTheme.accentAmber : AppTheme.textSecondary,
                    size: 20,
                  ),
                  onPressed: () {
                    final nowSaved = ref
                        .read(savedIncidentsControllerProvider.notifier)
                        .toggleBookmark(incident.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Text(
                          nowSaved
                              ? 'Incident saved to your local bookmarks.'
                              : 'Removed from saved bookmarks.',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Exact street address & place metadata
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.borderSubtle),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _InfoRow(
                    icon: Icons.place_rounded,
                    label: 'Exact Address',
                    value: incident.address,
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.storefront_rounded,
                    label: 'Location / Place',
                    value:
                        '${incident.placeName} (${_formatPlaceType(incident.placeType)})',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.schedule_rounded,
                    label: 'Reported',
                    value: timeFormatter.format(incident.occurredAt.toLocal()),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.local_police_outlined,
                    label: 'Source Agency',
                    value: incident.sourceAgency,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Street View Static Thumbnail + 3D/Interactive launchers
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 168,
                width: double.infinity,
                child: streetViewUrl != null
                    ? CachedNetworkImage(
                        imageUrl: streetViewUrl,
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String url) =>
                            const _StreetViewFallbackCard(
                          isLoading: true,
                          placeName: 'Loading Street View...',
                          coordinates: '',
                        ),
                        errorWidget:
                            (BuildContext context, String url, Object error) =>
                                _StreetViewFallbackCard(
                          isLoading: false,
                          placeName: incident.placeName,
                          coordinates:
                              '${incident.geo.latitude.toStringAsFixed(5)}, ${incident.geo.longitude.toStringAsFixed(5)}',
                        ),
                      )
                    : _StreetViewFallbackCard(
                        isLoading: false,
                        placeName: incident.placeName,
                        coordinates:
                            '${incident.geo.latitude.toStringAsFixed(5)}, ${incident.geo.longitude.toStringAsFixed(5)}',
                      ),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _open3dInspection(context),
                    icon: const Icon(Icons.view_in_ar_rounded, size: 18),
                    label: const Text('Inspect in 3D'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openExternalStreetView(context),
                    icon: const Icon(Icons.streetview_rounded, size: 18),
                    label: const Text('Street View'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textPrimary,
                      side: const BorderSide(color: AppTheme.borderSubtle),
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            if (incident.allegedOffender != null) ...<Widget>[
              const SizedBox(height: 16),
              AllegedOffenderCard(
                offender: incident.allegedOffender!,
                onRequestRemoval: onRequestRemoval != null
                    ? () => onRequestRemoval!(incident)
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _BadgePill extends StatelessWidget {
  const _BadgePill({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 16, color: AppTheme.accentCyan),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StreetViewFallbackCard extends StatelessWidget {
  const _StreetViewFallbackCard({
    required this.isLoading,
    required this.placeName,
    required this.coordinates,
  });

  final bool isLoading;
  final String placeName;
  final String coordinates;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF132238),
            Color(0xFF0E1726),
          ],
        ),
        border: Border.all(color: AppTheme.borderSubtle),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (isLoading)
            const CircularProgressIndicator(strokeWidth: 2)
          else
            const Icon(
              Icons.streetview_rounded,
              size: 36,
              color: AppTheme.accentCyan,
            ),
          const SizedBox(height: 8),
          Text(
            placeName,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            coordinates.isNotEmpty
                ? 'Street View Preview • $coordinates'
                : 'Configure GOOGLE_MAPS_API_KEY for Street View imagery',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
