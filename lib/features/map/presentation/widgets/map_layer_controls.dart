import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../map_controller.dart';

/// Floating toggle chips for map overlays and car-navigation follow mode:
/// - Historical Territories
/// - Public Cameras (Civic Transparency)
/// - Residential Density Heatmap (Anonymized Neighborhood Cells)
/// - Car-Nav Follow / 3D Tilt
class MapLayerControls extends ConsumerWidget {
  const MapLayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layers = ref.watch(
      mapControllerProvider.select(
        (state) => (
          showTerritories: state.showTerritoriesLayer,
          showCameras: state.showCamerasLayer,
          showDensity: state.showResidentialDensityLayer,
          carFollowMode: state.carFollowMode,
        ),
      ),
    );
    final controller = ref.read(mapControllerProvider.notifier);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _LayerChip(
            label: 'Historical Territories',
            icon: Icons.layers_outlined,
            active: layers.showTerritories,
            activeColor: AppTheme.accentAmber,
            onTap: controller.toggleTerritoriesLayer,
          ),
          const SizedBox(width: 8),
          _LayerChip(
            label: 'Public Cameras',
            icon: Icons.videocam_outlined,
            active: layers.showCameras,
            activeColor: AppTheme.accentCyan,
            onTap: controller.toggleCamerasLayer,
          ),
          const SizedBox(width: 8),
          _LayerChip(
            label: 'Residential Density',
            icon: Icons.blur_circular_rounded,
            active: layers.showDensity,
            activeColor: AppTheme.accentPurple,
            onTap: controller.toggleResidentialDensityLayer,
          ),
          const SizedBox(width: 8),
          _LayerChip(
            label: layers.carFollowMode ? '3D Car-Nav ON' : '3D Car-Nav OFF',
            icon: Icons.navigation_rounded,
            active: layers.carFollowMode,
            activeColor: AppTheme.accentEmerald,
            onTap: controller.toggleCarFollowMode,
          ),
        ],
      ),
    );
  }
}

class _LayerChip extends StatelessWidget {
  const _LayerChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final Color activeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active
          ? activeColor.withValues(alpha: 0.22)
          : AppTheme.surfaceDark.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? activeColor : AppTheme.borderSubtle,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                size: 14,
                color: active ? activeColor : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: active ? AppTheme.textPrimary : AppTheme.textSecondary,
                  fontSize: 11.5,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
