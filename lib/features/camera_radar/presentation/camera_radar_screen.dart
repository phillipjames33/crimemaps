import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/compliance_constants.dart';
import '../../../core/geo/geohash_util.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/auth_sheet.dart';
import '../domain/camera_model.dart';
import 'camera_radar_controller.dart';
import 'widgets/camera_alert_banner.dart';

/// Civic Transparency, Public Data Mapping & Privacy Awareness dashboard.
class CameraRadarScreen extends ConsumerWidget {
  const CameraRadarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(ComplianceConstants.cameraRadarTitle),
        actions: const <Widget>[
          AccountActionChip(),
        ],
      ),
      body: const Column(
        children: <Widget>[
          CameraAlertBannerHost(),
          Expanded(child: _CameraRadarBody()),
        ],
      ),
    );
  }
}

class _CameraRadarBody extends StatelessWidget {
  const _CameraRadarBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: const <Widget>[
        _TransparencyHeader(),
        SizedBox(height: 12),
        _SettingsCard(),
        SizedBox(height: 12),
        _SimulateButton(),
        SizedBox(height: 16),
        _NearbyCamerasSection(),
        SizedBox(height: 16),
        _DensitySection(),
        SizedBox(height: 16),
        ReportPublicCameraForm(),
      ],
    );
  }
}

class _TransparencyHeader extends StatelessWidget {
  const _TransparencyHeader();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.policy_outlined, color: AppTheme.accentCyan),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ComplianceConstants.cameraRadarSubtitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Crime Maps maps publicly documented infrastructure cameras '
              '(ALPR, traffic and red-light) so communities can understand '
              'what surveillance exists in public space. Data comes from '
              'open civic sources and community reports of public '
              'infrastructure only. Private home cameras are never pinned; '
              'residential data appears only as anonymized neighborhood '
              'density.',
              style: TextStyle(color: AppTheme.textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsCard extends ConsumerWidget {
  const _SettingsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(
      cameraRadarControllerProvider.select((s) => s.settings),
    );
    final controller = ref.read(cameraRadarControllerProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: const Text('Public camera zone notices'),
              subtitle: const Text(
                'Show an informational notice when entering a documented '
                'public camera zone.',
              ),
              value: settings.enabled,
              onChanged: (value) => controller.setEnabled(enabled: value),
            ),
            SwitchListTile(
              title: const Text('Audio chime'),
              subtitle: const Text('Briefly lowers music volume for the chime.'),
              value: settings.audioChime,
              onChanged: settings.enabled
                  ? (value) => controller.setAudioChime(enabled: value)
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: <Widget>[
                  const Expanded(
                    child: Text(
                      'Notice radius',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    '${settings.radiusMeters.round()} m',
                    style: const TextStyle(color: AppTheme.accentCyan),
                  ),
                ],
              ),
            ),
            Slider(
              min: 100,
              max: 500,
              divisions: 8,
              label: '${settings.radiusMeters.round()} m',
              value: settings.radiusMeters.clamp(100.0, 500.0),
              onChanged: settings.enabled ? controller.setRadiusMeters : null,
            ),
            SwitchListTile(
              title: const Text('Residential density heatmap'),
              subtitle: const Text(
                'Anonymized neighborhood-level density only. No individual '
                'homes are ever shown.',
              ),
              value: settings.showResidentialDensityHeatmap,
              onChanged: (value) =>
                  controller.setShowResidentialDensityHeatmap(enabled: value),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimulateButton extends ConsumerWidget {
  const _SimulateButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () => ref
          .read(cameraRadarControllerProvider.notifier)
          .simulateProximityCheck(),
      icon: const Icon(Icons.radar),
      label: const Text('Simulate Camera Zone Check'),
    );
  }
}

class _NearbyCamerasSection extends ConsumerWidget {
  const _NearbyCamerasSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameras = ref.watch(
      cameraRadarControllerProvider.select((s) => s.cameras),
    );
    final lat = ref.watch(
      cameraRadarControllerProvider.select((s) => s.userLatitude),
    );
    final lng = ref.watch(
      cameraRadarControllerProvider.select((s) => s.userLongitude),
    );

    final entries = cameras.map((camera) {
      final distance = (lat == null || lng == null)
          ? null
          : GeohashUtil.haversineDistanceMeters(
              lat1: lat,
              lng1: lng,
              lat2: camera.latitude,
              lng2: camera.longitude,
            );
      return (camera: camera, distance: distance);
    }).toList()
      ..sort((a, b) {
        final da = a.distance ?? double.infinity;
        final db = b.distance ?? double.infinity;
        return da.compareTo(db);
      });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Nearby public infrastructure cameras',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        if (entries.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No cached public cameras for this area yet. Move into a new '
                'area or run the simulated check.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          )
        else
          for (final entry in entries)
            Card(
              child: ListTile(
                leading: Icon(
                  _iconFor(entry.camera.type),
                  color: _colorFor(entry.camera.type),
                ),
                title: Text(entry.camera.operatorName),
                subtitle: Text(
                  '${CameraAlertBanner.typeLabel(entry.camera.type)}'
                  '${entry.camera.verified ? '' : ' • Pending verification'}',
                ),
                trailing: entry.distance == null
                    ? null
                    : Text(
                        _formatDistance(entry.distance!),
                        style: const TextStyle(
                          color: AppTheme.accentCyan,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
      ],
    );
  }

  static String _formatDistance(double meters) {
    if (meters >= 1000) return '${(meters / 1000).toStringAsFixed(1)} km';
    return '${meters.round()} m';
  }

  static IconData _iconFor(PublicCameraType type) {
    switch (type) {
      case PublicCameraType.alprFlock:
        return Icons.sensors;
      case PublicCameraType.traffic:
        return Icons.traffic;
      case PublicCameraType.redLight:
        return Icons.stop_circle_outlined;
    }
  }

  static Color _colorFor(PublicCameraType type) {
    switch (type) {
      case PublicCameraType.alprFlock:
        return AppTheme.accentAmber;
      case PublicCameraType.traffic:
        return AppTheme.accentCyan;
      case PublicCameraType.redLight:
        return AppTheme.accentCrimson;
    }
  }
}

class _DensitySection extends ConsumerWidget {
  const _DensitySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final show = ref.watch(
      cameraRadarControllerProvider.select(
        (s) => s.settings.showResidentialDensityHeatmap,
      ),
    );
    final cells = ref.watch(
      cameraRadarControllerProvider.select((s) => s.densityCells),
    );
    if (!show) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Residential density (anonymized)',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        for (final cell in cells)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    cell.neighborhoodName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: cell.normalizedDensity.clamp(0.0, 1.0),
                    minHeight: 6,
                    color: AppTheme.accentPurple,
                    backgroundColor: AppTheme.surfaceElevated,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// Opt-in form for reporting PUBLIC infrastructure cameras. Private
/// residential cameras are blocked with a clear explanation (anti-doxxing).
class ReportPublicCameraForm extends ConsumerStatefulWidget {
  const ReportPublicCameraForm({super.key});

  @override
  ConsumerState<ReportPublicCameraForm> createState() =>
      _ReportPublicCameraFormState();
}

class _ReportPublicCameraFormState
    extends ConsumerState<ReportPublicCameraForm> {
  final TextEditingController _operatorController = TextEditingController();
  final TextEditingController _cityController =
      TextEditingController(text: 'Atlanta');
  final TextEditingController _stateController =
      TextEditingController(text: 'GA');

  PublicCameraType _type = PublicCameraType.alprFlock;
  bool _isPrivateResidence = false;
  String? _error;
  String? _success;
  bool _submitting = false;

  static const String _privateBlockedMessage =
      'Private residential cameras (such as home doorbell cameras) cannot be '
      'reported or pinned. Crime Maps only maps public infrastructure '
      'cameras to protect residents from doxxing. Residential data appears '
      'only as anonymized neighborhood density.';

  @override
  void dispose() {
    _operatorController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isPrivateResidence) {
      setState(() {
        _error = _privateBlockedMessage;
        _success = null;
      });
      return;
    }
    final operatorName = _operatorController.text.trim();
    if (operatorName.isEmpty) {
      setState(() {
        _error = 'Please enter the operating agency or organization.';
        _success = null;
      });
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
      _success = null;
    });

    final radar = ref.read(cameraRadarControllerProvider);
    final lat = radar.userLatitude ?? 33.7756;
    final lng = radar.userLongitude ?? -84.3963;
    final city = _cityController.text.trim();

    final error = await ref
        .read(cameraRadarControllerProvider.notifier)
        .submitPublicCamera(
          CameraSubmissionRequest(
            type: _type,
            operatorName: operatorName,
            latitude: lat,
            longitude: lng,
            citySlug: city.toLowerCase().replaceAll(RegExp(r'\s+'), '-'),
            stateCode: _stateController.text.trim().toUpperCase(),
            isPrivateResidence: _isPrivateResidence,
          ),
        );

    if (!mounted) return;
    setState(() {
      _submitting = false;
      _error = error;
      _success = error == null
          ? 'Thank you. Your public infrastructure report was submitted '
              'for community verification.'
          : null;
      if (error == null) _operatorController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Report Public Infrastructure Camera',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Opt-in. Public infrastructure only (ALPR, traffic, '
              'red-light). Your current location is used; no street '
              'addresses are collected.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PublicCameraType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Camera type'),
              items: <DropdownMenuItem<PublicCameraType>>[
                for (final type in PublicCameraType.values)
                  DropdownMenuItem<PublicCameraType>(
                    value: type,
                    child: Text(CameraAlertBanner.typeLabel(type)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _type = value);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _operatorController,
              decoration: const InputDecoration(
                labelText: 'Operating agency / organization',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(labelText: 'City'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _stateController,
                    decoration: const InputDecoration(labelText: 'State'),
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('This is a private residential camera'),
              value: _isPrivateResidence,
              onChanged: (value) => setState(() {
                _isPrivateResidence = value ?? false;
                _error = _isPrivateResidence ? _privateBlockedMessage : null;
                _success = null;
              }),
            ),
            if (_error != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentCrimson.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentCrimson),
                ),
                child: Text(
                  _error!,
                  key: const ValueKey<String>('camera-report-error'),
                  style: const TextStyle(color: AppTheme.textPrimary),
                ),
              ),
            if (_success != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  _success!,
                  style: const TextStyle(color: AppTheme.accentEmerald),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: const Text('Submit Public Camera Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
