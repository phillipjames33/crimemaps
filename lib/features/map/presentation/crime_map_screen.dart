import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../core/geo/location_service.dart';
import '../../../core/mock/seed_data.dart';
import '../../../core/theme/app_theme.dart';
import '../../camera_radar/domain/camera_model.dart';
import '../../incidents/domain/incident_model.dart';
import '../../incidents/domain/incident_repository.dart';
import '../../incidents/presentation/incident_providers.dart';
import '../../incidents/presentation/widgets/incident_detail_sheet.dart';
import '../../territories/domain/territory_model.dart';
import '../../territories/presentation/territory_providers.dart';
import '../../territories/presentation/widgets/territory_context_sheet.dart';
import '../data/map_style_loader.dart';
import '../domain/map_viewport_state.dart';
import 'map_controller.dart';
import 'widgets/map_layer_controls.dart';
import 'widgets/scope_toggle_bar.dart';

/// Full-screen dark-mode car-navigation Google Map with:
/// - Zoom-aware incident clustering & color-coded severity markers
/// - Translucent Historical Territory polygon overlays (tap-to-inspect)
/// - Public Camera Transparency markers (ALPR / Traffic / Red-Light only)
/// - Anonymized Neighborhood Residential Density circles (never exact house pins)
/// - Bottom incident peek carousel for quick inspection across devices/emulators
class CrimeMapScreen extends ConsumerStatefulWidget {
  const CrimeMapScreen({
    super.key,
    this.cameras,
    this.densityCells,
    this.topBanner,
    this.onRequestOffenderRemoval,
  });

  final List<PublicCamera>? cameras;
  final List<ResidentialDensityCell>? densityCells;
  final Widget? topBanner;
  final void Function(Incident incident)? onRequestOffenderRemoval;

  @override
  ConsumerState<CrimeMapScreen> createState() => _CrimeMapScreenState();
}

class _CrimeMapScreenState extends ConsumerState<CrimeMapScreen> {
  GoogleMapController? _mapController;
  String? _darkMapStyle;
  double _renderedZoom = 13.5;
  bool _isUpdatingFromGesture = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadMapStyle());
  }

  Future<void> _loadMapStyle() async {
    final styleJson = await MapStyleLoader.loadDarkCarNavStyle();
    if (!mounted) return;
    setState(() {
      _darkMapStyle = styleJson;
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _mapController = null;
    super.dispose();
  }

  Future<void> _animateCameraToState(MapViewportState viewport) async {
    final controller = _mapController;
    if (controller == null) return;
    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(viewport.centerLat, viewport.centerLng),
            zoom: viewport.zoom,
            tilt: viewport.tilt,
            bearing: viewport.bearing,
          ),
        ),
      );
    } catch (_) {
      // Ignore camera animation errors if platform map view is detached.
    }
  }

  Future<void> _focusCoordinate(
    double latitude,
    double longitude, {
    double? zoom,
  }) async {
    final controller = _mapController;
    if (controller == null) return;
    try {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: zoom ?? math.max(_renderedZoom, 14.5),
            tilt: ref.read(mapControllerProvider).carFollowMode ? 45.0 : 0.0,
          ),
        ),
      );
    } catch (_) {
      // Ignore if map view is detached.
    }
  }

  void _openIncidentSheet(Incident incident) {
    unawaited(
      _focusCoordinate(
        incident.geo.latitude,
        incident.geo.longitude,
        zoom: 15.2,
      ),
    );
    unawaited(
      IncidentDetailSheet.show(
        context,
        incident: incident,
        onRequestRemoval: widget.onRequestOffenderRemoval,
      ),
    );
  }

  void _openTerritorySheet(Territory territory) {
    unawaited(
      TerritoryContextSheet.show(
        context,
        territory: territory,
      ),
    );
  }

  Set<Marker> _buildMarkers({
    required List<Incident> incidents,
    required List<PublicCamera> cameras,
    required bool showIncidents,
    required bool showCameras,
  }) {
    final markers = <Marker>{};

    if (showIncidents && incidents.isNotEmpty) {
      markers.addAll(_buildZoomClusteredIncidentMarkers(incidents));
    }

    if (showCameras && cameras.isNotEmpty) {
      for (final camera in cameras) {
        markers.add(
          Marker(
            markerId: MarkerId('cam_${camera.id}'),
            position: LatLng(camera.latitude, camera.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              _cameraMarkerHue(camera.type),
            ),
            infoWindow: InfoWindow(
              title: _cameraTypeLabel(camera.type),
              snippet: camera.operatorName,
            ),
          ),
        );
      }
    }

    return markers;
  }

  Set<Marker> _buildZoomClusteredIncidentMarkers(List<Incident> incidents) {
    // At neighborhood street zoom, show every incident individually.
    if (_renderedZoom >= 12.2 || incidents.length <= 1) {
      return incidents.map(_buildSingleIncidentMarker).toSet();
    }

    // Zoom-bucket spatial clustering for city/state zoom levels.
    final zoomDelta = (12.0 - _renderedZoom).clamp(0.0, 6.0);
    final gridDegrees = 0.05 * math.pow(2.0, zoomDelta * 0.85);
    final buckets = <String, List<Incident>>{};

    for (final incident in incidents) {
      final latBucket = (incident.geo.latitude / gridDegrees).floor();
      final lngBucket = (incident.geo.longitude / gridDegrees).floor();
      final key = '${latBucket}_$lngBucket';
      buckets.putIfAbsent(key, () => <Incident>[]).add(incident);
    }

    final result = <Marker>{};
    for (final entry in buckets.entries) {
      final group = entry.value;
      if (group.length == 1) {
        result.add(_buildSingleIncidentMarker(group.first));
      } else {
        double sumLat = 0.0;
        double sumLng = 0.0;
        for (final item in group) {
          sumLat += item.geo.latitude;
          sumLng += item.geo.longitude;
        }
        final avgLat = sumLat / group.length;
        final avgLng = sumLng / group.length;

        result.add(
          Marker(
            markerId: MarkerId('cluster_${entry.key}'),
            position: LatLng(avgLat, avgLng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRose,
            ),
            infoWindow: InfoWindow(
              title: '${group.length} Incidents in Sector',
              snippet: 'Tap to zoom into street level',
            ),
            onTap: () {
              final nextZoom = (_renderedZoom + 2.4).clamp(12.5, 16.0);
              unawaited(_focusCoordinate(avgLat, avgLng, zoom: nextZoom));
            },
          ),
        );
      }
    }
    return result;
  }

  Marker _buildSingleIncidentMarker(Incident incident) {
    return Marker(
      markerId: MarkerId('inc_${incident.id}'),
      position: LatLng(incident.geo.latitude, incident.geo.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        _incidentMarkerHue(incident.category),
      ),
      infoWindow: InfoWindow(
        title: incident.title,
        snippet: incident.placeName,
        onTap: () => _openIncidentSheet(incident),
      ),
      onTap: () => _openIncidentSheet(incident),
    );
  }

  Set<Polygon> _buildTerritoryPolygons(List<Territory> territories) {
    final polygons = <Polygon>{};
    for (final territory in territories) {
      if (territory.polygonPoints.length < 3) continue;
      final baseColor = _parseHexColor(territory.colorHex);
      polygons.add(
        Polygon(
          polygonId: PolygonId('terr_${territory.id}'),
          points: territory.polygonPoints
              .map(
                (TerritoryVertex v) => LatLng(v.latitude, v.longitude),
              )
              .toList(),
          fillColor: baseColor.withValues(alpha: 0.18),
          strokeColor: baseColor.withValues(alpha: 0.85),
          strokeWidth: 2,
          consumeTapEvents: true,
          onTap: () => _openTerritorySheet(territory),
        ),
      );
    }
    return polygons;
  }

  Set<Circle> _buildDensityCircles(List<ResidentialDensityCell> cells) {
    final circles = <Circle>{};
    for (final cell in cells) {
      final opacity = (0.10 + (cell.normalizedDensity * 0.22)).clamp(0.10, 0.34);
      circles.add(
        Circle(
          circleId: CircleId('density_${cell.geohashCell}'),
          center: LatLng(cell.centerLat, cell.centerLng),
          radius: cell.radiusMeters,
          fillColor: AppTheme.accentPurple.withValues(alpha: opacity),
          strokeColor: AppTheme.accentPurple.withValues(alpha: 0.65),
          strokeWidth: 1,
        ),
      );
    }
    return circles;
  }

  double _incidentMarkerHue(IncidentCategory category) {
    switch (category) {
      case IncidentCategory.violent:
        return BitmapDescriptor.hueRed;
      case IncidentCategory.property:
        return BitmapDescriptor.hueOrange;
      case IncidentCategory.trafficDui:
        return BitmapDescriptor.hueAzure;
      case IncidentCategory.other:
        return BitmapDescriptor.hueViolet;
    }
  }

  double _cameraMarkerHue(PublicCameraType type) {
    switch (type) {
      case PublicCameraType.alprFlock:
        return BitmapDescriptor.hueCyan;
      case PublicCameraType.traffic:
        return BitmapDescriptor.hueGreen;
      case PublicCameraType.redLight:
        return BitmapDescriptor.hueYellow;
    }
  }

  String _cameraTypeLabel(PublicCameraType type) {
    switch (type) {
      case PublicCameraType.alprFlock:
        return 'Public ALPR Camera (Civic Transparency)';
      case PublicCameraType.traffic:
        return 'Public DOT Traffic Camera';
      case PublicCameraType.redLight:
        return 'Intersection Red-Light Camera';
    }
  }

  Color _parseHexColor(String hex) {
    final clean = hex.replaceFirst('#', '').trim();
    if (clean.length == 6) {
      final parsed = int.tryParse('FF$clean', radix: 16);
      if (parsed != null) return Color(parsed);
    }
    return AppTheme.accentAmber;
  }

  @override
  Widget build(BuildContext context) {
    final viewport = ref.watch(mapControllerProvider);
    final incidentsAsync = ref.watch(scopedIncidentsProvider);
    final territoriesAsync = ref.watch(territoriesForAreaProvider);

    ref.listen<MapViewportState>(mapControllerProvider,
        (MapViewportState? previous, MapViewportState next) {
      if (_isUpdatingFromGesture) return;
      final cameraChanged = previous == null ||
          previous.centerLat != next.centerLat ||
          previous.centerLng != next.centerLng ||
          previous.zoom != next.zoom ||
          previous.tilt != next.tilt ||
          previous.bearing != next.bearing;
      if (cameraChanged) {
        unawaited(_animateCameraToState(next));
      }
    });

    ref.listen<AsyncValue<UserLocationFix>>(userLocationStreamProvider,
        (AsyncValue<UserLocationFix>? previous,
            AsyncValue<UserLocationFix> next) {
      next.whenData((UserLocationFix fix) {
        if (!fix.isSimulated && ref.read(mapControllerProvider).carFollowMode) {
          ref.read(mapControllerProvider.notifier).updateFromUserLocation(
                latitude: fix.latitude,
                longitude: fix.longitude,
                heading: fix.heading,
              );
        }
      });
    });

    final incidents = incidentsAsync.when(
      data: (List<Incident> data) => data,
      loading: () => const <Incident>[],
      error: (Object error, StackTrace stackTrace) => const <Incident>[],
    );

    final territories = territoriesAsync.when(
      data: (List<Territory> data) => data,
      loading: () => const <Territory>[],
      error: (Object error, StackTrace stackTrace) => const <Territory>[],
    );

    final activeCameras = (widget.cameras ?? SeedData.buildSeedCameras())
        .where((PublicCamera cam) {
      if (viewport.scope == MapScope.state) {
        return cam.stateCode.toUpperCase() ==
            viewport.activeStateCode.toUpperCase();
      }
      return cam.citySlug.toLowerCase() ==
          viewport.activeCitySlug.toLowerCase();
    }).toList();

    final densityCells =
        widget.densityCells ?? SeedData.buildSeedResidentialDensityCells();

    final markers = _buildMarkers(
      incidents: incidents,
      cameras: activeCameras,
      showIncidents: viewport.showIncidentsLayer,
      showCameras: viewport.showCamerasLayer,
    );

    final polygons = viewport.showTerritoriesLayer
        ? _buildTerritoryPolygons(territories)
        : const <Polygon>{};

    final circles = viewport.showResidentialDensityLayer
        ? _buildDensityCircles(densityCells)
        : const <Circle>{};

    final mapWidget = GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(viewport.centerLat, viewport.centerLng),
        zoom: viewport.zoom,
        tilt: viewport.tilt,
        bearing: viewport.bearing,
      ),
      style: _darkMapStyle,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      compassEnabled: true,
      buildingsEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
      markers: markers,
      polygons: polygons,
      circles: circles,
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      onCameraMove: (CameraPosition position) {
        if ((position.zoom - _renderedZoom).abs() >= 0.4) {
          setState(() {
            _renderedZoom = position.zoom;
          });
        }
      },
      onCameraIdle: () {
        _isUpdatingFromGesture = false;
      },
      onCameraMoveStarted: () {
        _isUpdatingFromGesture = true;
      },
    );

    final bottomCarousel = Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: _IncidentPeekCarousel(
          incidentsAsync: incidentsAsync,
          territories: territories,
          showTerritories: viewport.showTerritoriesLayer,
          activeScopeLabel: _scopeSummaryLabel(viewport),
          onTapIncident: _openIncidentSheet,
          onTapTerritory: _openTerritorySheet,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: Stack(
        children: <Widget>[
          // Full-screen dark car-navigation Google Map
          Positioned.fill(child: mapWidget),

          // Top floating car-nav scope bar, optional camera radar banner & layer toggles
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const ScopeToggleBar(),
                    if (widget.topBanner != null) ...<Widget>[
                      const SizedBox(height: 8),
                      widget.topBanner!,
                    ],
                    const SizedBox(height: 8),
                    const MapLayerControls(),
                  ],
                ),
              ),
            ),
          ),

          // Bottom incident peek carousel + territory quick access
          bottomCarousel,
        ],
      ),
    );
  }

  String _scopeSummaryLabel(MapViewportState viewport) {
    switch (viewport.scope) {
      case MapScope.area:
        return 'Within 5 mi • ${viewport.activeCityName}';
      case MapScope.city:
        return '${viewport.activeCityName}, ${viewport.activeStateCode}';
      case MapScope.state:
        return 'Statewide • ${viewport.activeStateCode}';
    }
  }
}

class _IncidentPeekCarousel extends StatelessWidget {
  const _IncidentPeekCarousel({
    required this.incidentsAsync,
    required this.territories,
    required this.showTerritories,
    required this.activeScopeLabel,
    required this.onTapIncident,
    required this.onTapTerritory,
  });

  final AsyncValue<List<Incident>> incidentsAsync;
  final List<Territory> territories;
  final bool showTerritories;
  final String activeScopeLabel;
  final void Function(Incident incident) onTapIncident;
  final void Function(Territory territory) onTapTerritory;

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

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat('h:mm a');

    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppTheme.bgDark.withValues(alpha: 0.0),
            AppTheme.bgDark.withValues(alpha: 0.92),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.borderSubtle),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.radar_rounded,
                        size: 14,
                        color: AppTheme.accentCyan,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        incidentsAsync.when(
                          data: (List<Incident> list) =>
                              '${list.length} Incidents • $activeScopeLabel',
                          loading: () => 'Loading incidents...',
                          error: (Object err, StackTrace st) =>
                              'Unable to load incidents',
                        ),
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (showTerritories && territories.isNotEmpty)
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => onTapTerritory(territories.first),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentAmber.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppTheme.accentAmber.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.history_edu_rounded,
                            size: 13,
                            color: AppTheme.accentAmber,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${territories.length} Historical Context',
                            style: const TextStyle(
                              color: AppTheme.accentAmber,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 108,
            child: incidentsAsync.when(
              loading: () => const Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              error: (Object error, StackTrace stackTrace) => const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Error loading incidents for this scope.',
                    style: TextStyle(
                      color: AppTheme.accentCrimson,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              data: (List<Incident> incidents) {
                if (incidents.isEmpty) {
                  return Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceDark.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.borderSubtle),
                      ),
                      child: const Text(
                        'No public incidents match the current scope or search filter.',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  scrollDirection: Axis.horizontal,
                  itemCount: incidents.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final incident = incidents[index];
                    final severityColor = _severityColor(incident.severity);

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => onTapIncident(incident),
                      child: Container(
                        width: 268,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceDark.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: severityColor.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: severityColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  incident.severity.name.toUpperCase(),
                                  style: TextStyle(
                                    color: severityColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                if (incident.allegedOffender != null)
                                  Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentAmber
                                          .withValues(alpha: 0.16),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text(
                                      'Booking',
                                      style: TextStyle(
                                        color: AppTheme.accentAmber,
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: Text(
                                    timeFormat
                                        .format(incident.occurredAt.toLocal()),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              incident.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.place_outlined,
                                  size: 13,
                                  color: AppTheme.accentCyan,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${incident.placeName} • ${incident.address}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
