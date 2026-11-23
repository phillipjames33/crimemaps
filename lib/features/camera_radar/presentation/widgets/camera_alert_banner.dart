import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/compliance_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/camera_model.dart';
import '../camera_radar_controller.dart';

/// Top-of-screen animated banner for Civic Transparency & Privacy Awareness.
///
/// Informational only: it tells the user they are entering an area with a
/// publicly documented infrastructure camera (ALPR / traffic / red-light).
class CameraAlertBanner extends StatelessWidget {
  const CameraAlertBanner({
    super.key,
    required this.alert,
    required this.onDismiss,
  });

  final CameraProximityAlert alert;
  final VoidCallback onDismiss;

  static String typeLabel(PublicCameraType type) {
    switch (type) {
      case PublicCameraType.alprFlock:
        return 'ALPR';
      case PublicCameraType.traffic:
        return 'Traffic Camera';
      case PublicCameraType.redLight:
        return 'Red-Light Camera';
    }
  }

  @override
  Widget build(BuildContext context) {
    final meters = alert.distanceMeters.round();
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) {
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * -24),
            child: child,
          ),
        );
      },
      child: Semantics(
        liveRegion: true,
        container: true,
        label: '${ComplianceConstants.cameraZoneBannerPrefix}. '
            '${alert.camera.operatorName}. $meters meters.',
        child: Material(
          color: AppTheme.surfaceElevated,
          elevation: 6,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.accentAmber, width: 1.2),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.videocam_outlined,
                  color: AppTheme.accentAmber,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text(
                        ComplianceConstants.cameraZoneBannerPrefix,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        alert.camera.operatorName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${typeLabel(alert.camera.type)} • $meters m away • '
                        'Civic Transparency & Privacy Awareness',
                        style: const TextStyle(
                          color: AppTheme.accentCyan,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Dismiss',
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Connects [CameraAlertBanner] to [CameraRadarController]. Place at the top
/// of a screen (or in a `Stack`) so it slides in when an alert is active.
class CameraAlertBannerHost extends ConsumerWidget {
  const CameraAlertBannerHost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alert = ref.watch(
      cameraRadarControllerProvider.select((s) => s.activeAlert),
    );
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: alert == null
          ? const SizedBox.shrink(key: ValueKey<String>('no-camera-alert'))
          : Padding(
              key: ValueKey<String>('camera-alert-${alert.camera.id}'),
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
              child: CameraAlertBanner(
                alert: alert,
                onDismiss: () => ref
                    .read(cameraRadarControllerProvider.notifier)
                    .dismissAlert(),
              ),
            ),
    );
  }
}
