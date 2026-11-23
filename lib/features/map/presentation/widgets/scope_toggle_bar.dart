import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../incidents/domain/incident_repository.dart';
import '../map_controller.dart';

/// Floating dark car-navigation header combining quick scope pills
/// (`My Area (5 mi) | City | State`), an incident/city search bar, and
/// one-tap city quick-jump presets.
class ScopeToggleBar extends ConsumerStatefulWidget {
  const ScopeToggleBar({super.key});

  @override
  ConsumerState<ScopeToggleBar> createState() => _ScopeToggleBarState();
}

class _ScopeToggleBarState extends ConsumerState<ScopeToggleBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeScope = ref.watch(
      mapControllerProvider.select((state) => state.scope),
    );
    final activeCitySlug = ref.watch(
      mapControllerProvider.select((state) => state.activeCitySlug),
    );
    final activeCityName = ref.watch(
      mapControllerProvider.select((state) => state.activeCityName),
    );
    final activeStateCode = ref.watch(
      mapControllerProvider.select((state) => state.activeStateCode),
    );
    final searchQuery = ref.watch(
      mapControllerProvider.select((state) => state.searchQuery),
    );

    final controller = ref.read(mapControllerProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Search input
          SizedBox(
            height: 42,
            child: TextField(
              controller: _searchController,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 13.5,
              ),
              textInputAction: TextInputAction.search,
              onChanged: controller.setSearchQuery,
              onSubmitted: controller.submitSearch,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                hintText: 'Search incidents, address, or city ($activeCityName, $activeStateCode)',
                hintStyle: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12.5,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 19,
                  color: AppTheme.accentCyan,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: AppTheme.textSecondary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          controller.setSearchQuery('');
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Quick Scope Pills: My Area (5 mi) | City | State
          Row(
            children: <Widget>[
              Expanded(
                child: _ScopePill(
                  label: 'My Area (5 mi)',
                  selected: activeScope == MapScope.area,
                  icon: Icons.my_location_rounded,
                  onTap: () => controller.setScope(MapScope.area),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ScopePill(
                  label: 'City',
                  selected: activeScope == MapScope.city,
                  icon: Icons.location_city_rounded,
                  onTap: () => controller.setScope(MapScope.city),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _ScopePill(
                  label: 'State',
                  selected: activeScope == MapScope.state,
                  icon: Icons.map_outlined,
                  onTap: () => controller.setScope(MapScope.state),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // City Quick-Jump Carousel
          SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: MapController.cityPresets.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(width: 6),
              itemBuilder: (BuildContext context, int index) {
                final preset = MapController.cityPresets[index];
                final isSelected = preset.citySlug == activeCitySlug;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    _searchController.clear();
                    controller.selectCityPreset(preset);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.accentCyan.withValues(alpha: 0.18)
                          : AppTheme.surfaceElevated,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.accentCyan
                            : AppTheme.borderSubtle,
                      ),
                    ),
                    child: Text(
                      preset.displayLabel,
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.accentCyan
                            : AppTheme.textSecondary,
                        fontSize: 11.5,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScopePill extends StatelessWidget {
  const _ScopePill({
    required this.label,
    required this.selected,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? AppTheme.accentCyan
          : AppTheme.surfaceElevated,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppTheme.accentCyan : AppTheme.borderSubtle,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                size: 14,
                color: selected
                    ? const Color(0xFF06131F)
                    : AppTheme.textSecondary,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF06131F)
                        : AppTheme.textPrimary,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
