import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/camera_radar/presentation/camera_radar_controller.dart';
import '../../features/camera_radar/presentation/camera_radar_screen.dart';
import '../../features/camera_radar/presentation/widgets/camera_alert_banner.dart';
import '../../features/compliance/presentation/dmca_report_dialog.dart';
import '../../features/compliance/presentation/mugshot_removal_sheet.dart';
import '../../features/creator_portal/presentation/creator_portal_screen.dart';
import '../../features/geo_radio/domain/track_model.dart';
import '../../features/geo_radio/presentation/geo_radio_controller.dart';
import '../../features/geo_radio/presentation/geo_radio_screen.dart';
import '../../features/geo_radio/presentation/widgets/persistent_mini_player.dart';
import '../../features/incidents/domain/incident_model.dart';
import '../../features/incidents/presentation/incident_providers.dart';
import '../../features/map/presentation/crime_map_screen.dart';
import '../../features/map/presentation/map_controller.dart';
import '../../features/monetization/presentation/ad_service.dart';
import '../../features/monetization/presentation/paywall_screen.dart';
import '../theme/app_theme.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'rootNavigator',
);

/// Opens the 100% free Record Removal / Expungement sheet for an incident.
Future<void> openFreeOffenderRemovalSheet(
  BuildContext context,
  WidgetRef ref,
  Incident incident,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.surfaceDark,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext sheetContext) {
      return MugshotRemovalSheet(
        incidentId: incident.id,
        offenderName: incident.allegedOffender?.name,
        onRedacted: () {
          unawaited(
            ref
                .read(incidentRepositoryProvider)
                .markOffenderRedacted(incident.id)
                .then((_) => ref.invalidate(scopedIncidentsProvider)),
          );
        },
      );
    },
  );
}

/// Opens the one-click DMCA Safe Harbor copyright infringement dialog and
/// immediately hides the flagged track from the Geo-Radio queue.
Future<void> openDmcaReportDialog(
  BuildContext context,
  WidgetRef ref,
  IndieTrack track,
) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return DmcaReportDialog(
        trackId: track.id,
        trackTitle: track.title,
        onFlagged: () {
          unawaited(
            ref.read(geoRadioControllerProvider.notifier).flagDmca(track.id),
          );
        },
      );
    },
  );
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/map',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return _CrimeMapsShellScaffold(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/map',
                name: 'map',
                builder: (BuildContext context, GoRouterState state) {
                  return const _MapBranchView();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/radio',
                name: 'radio',
                builder: (BuildContext context, GoRouterState state) {
                  return const _RadioBranchView();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/radar',
                name: 'radar',
                builder: (BuildContext context, GoRouterState state) {
                  return const CameraRadarScreen();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/creator',
                name: 'creator',
                builder: (BuildContext context, GoRouterState state) {
                  return const _CreatorBranchView();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/pro',
                name: 'pro',
                builder: (BuildContext context, GoRouterState state) {
                  return const PaywallScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _CrimeMapsShellScaffold extends ConsumerWidget {
  const _CrimeMapsShellScaffold({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sync active map city/ZIP into the Indie Geo-Radio queue whenever the user
    // jumps to another city on the map (using ref.listen, never side effects in build).
    ref.listen<({String slug, String name, String zip})>(
      mapControllerProvider.select(
        (s) => (
          slug: s.activeCitySlug,
          name: s.activeCityName,
          zip: s.activeZipCode,
        ),
      ),
      (previous, next) {
        if (previous?.slug != next.slug || previous?.zip != next.zip) {
          unawaited(
            ref.read(geoRadioControllerProvider.notifier).setCity(
                  GeoRadioCity(
                    slug: next.slug,
                    label: next.name,
                    zipCode: next.zip,
                  ),
                ),
          );
        }
      },
    );

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FreeTierAdBanner(
            onUpgradePressed: () => navigationShell.goBranch(4),
          ),
          PersistentMiniPlayer(
            onReportDmca: (IndieTrack track) {
              unawaited(openDmcaReportDialog(context, ref, track));
            },
          ),
          NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: (int index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.map_outlined),
                selectedIcon: Icon(Icons.map),
                label: 'Map',
              ),
              NavigationDestination(
                icon: Icon(Icons.radio_outlined),
                selectedIcon: Icon(Icons.radio),
                label: 'Geo-Radio',
              ),
              NavigationDestination(
                icon: Icon(Icons.videocam_outlined),
                selectedIcon: Icon(Icons.videocam),
                label: 'Radar',
              ),
              NavigationDestination(
                icon: Icon(Icons.cloud_upload_outlined),
                selectedIcon: Icon(Icons.cloud_upload),
                label: 'Creator',
              ),
              NavigationDestination(
                icon: Icon(Icons.workspace_premium_outlined),
                selectedIcon: Icon(Icons.workspace_premium),
                label: 'Pro',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapBranchView extends ConsumerWidget {
  const _MapBranchView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameras = ref.watch(
      cameraRadarControllerProvider.select((s) => s.cameras),
    );
    final densityCells = ref.watch(
      cameraRadarControllerProvider.select((s) => s.densityCells),
    );

    return CrimeMapScreen(
      cameras: cameras,
      densityCells: densityCells,
      topBanner: const CameraAlertBannerHost(),
      onRequestOffenderRemoval: (Incident incident) {
        unawaited(openFreeOffenderRemovalSheet(context, ref, incident));
      },
    );
  }
}

class _RadioBranchView extends ConsumerWidget {
  const _RadioBranchView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GeoRadioScreen(
      onReportDmca: (IndieTrack track) {
        unawaited(openDmcaReportDialog(context, ref, track));
      },
    );
  }
}

class _CreatorBranchView extends ConsumerWidget {
  const _CreatorBranchView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CreatorPortalScreen(
      onTrackPublished: (IndieTrack track) {
        unawaited(
          ref.read(geoRadioControllerProvider.notifier).addPublishedTrack(track),
        );
      },
      onTrackBoosted: (String trackId, String targetZip, DateTime boostedUntil) {
        unawaited(
          ref.read(geoRadioControllerProvider.notifier).applyBoost(
                trackId: trackId,
                targetZip: targetZip,
                boostedUntil: boostedUntil,
              ),
        );
      },
    );
  }
}
