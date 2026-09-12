import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/providers/theme.dart';
import '../../l10n/app_localizations.dart';
import '../theme/theme.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

/// Navigation item model describing each top-level destination.
class AppNavItem {
  final String label;
  final String path;
  final IconData icon;
  final IconData selectedIcon;
  final String tooltip;
  final String semanticsLabel;

  const AppNavItem({
    required this.label,
    required this.path,
    required this.icon,
    required this.selectedIcon,
    required this.tooltip,
    required this.semanticsLabel,
  });
}

/// The 4 primary navigation destinations: Home, Books, Profile, Settings.
List<AppNavItem> appNavItems(AppLocalizations l10n) => [
  AppNavItem(
    label: l10n.home,
    path: '/',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
    tooltip: l10n.navigate_home,
    semanticsLabel: l10n.home_tab,
  ),
  AppNavItem(
    label: l10n.books,
    path: '/books',
    icon: Icons.menu_book_outlined,
    selectedIcon: Icons.menu_book_rounded,
    tooltip: l10n.navigate_books,
    semanticsLabel: l10n.books_tab,
  ),
  AppNavItem(
    label: l10n.profile,
    path: '/profile',
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
    tooltip: l10n.navigate_profile,
    semanticsLabel: l10n.profile_tab,
  ),
  AppNavItem(
    label: l10n.settings,
    path: '/settings',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
    tooltip: l10n.navigate_settings,
    semanticsLabel: l10n.settings_tab,
  ),
];

/// Breakpoints used for responsive transitions.
class AppNavBreakpoints {
  /// Width threshold below which the bottom navigation bar is used,
  /// and at or above which the side navigation rail is used.
  static const double medium = 640.0;

  /// Width threshold at which the side navigation can automatically expand.
  static const double expanded = 1024.0;
}

/// Returns the navigation index corresponding to [path].
int getNavIndexForLocation(String path) {
  if (path.startsWith('/books')) return 1;
  if (path.startsWith('/profile')) return 2;
  if (path.startsWith('/settings')) return 3;
  if (path == '/' || path.isEmpty) return 0;
  return 0;
}

/// The responsive base layout shared across all routes inside [ShellRoute].
///
/// Automatically switches between a side navigation rail on large screens
/// (width >= 640) and a bottom navigation bar on smaller/mobile screens.
class AppBaseLayout extends ConsumerStatefulWidget {
  final Widget child;
  final String? currentPath;

  const AppBaseLayout({super.key, required this.child, this.currentPath});

  @override
  ConsumerState<AppBaseLayout> createState() => _AppBaseLayoutState();
}

class _AppBaseLayoutState extends ConsumerState<AppBaseLayout> {
  final GlobalKey _contentKey = GlobalKey(debugLabel: 'app_shell_content');
  bool? _manuallyExpanded;

  void _onNavigate(BuildContext context, int index) {
    final navItems = appNavItems(_getAppLocalizations(context));
    if (index < 0 || index >= navItems.length) return;
    final targetPath = navItems[index].path;
    final currentPath =
        widget.currentPath ?? GoRouterState.of(context).uri.path;
    if (currentPath != targetPath) {
      context.go(targetPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPath =
        widget.currentPath ?? GoRouterState.of(context).uri.path;
    final selectedIndex = getNavIndexForLocation(currentPath);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth >= AppNavBreakpoints.medium;
        final isExtended =
            _manuallyExpanded ??
            (constraints.maxWidth >= AppNavBreakpoints.expanded);

        if (isLargeScreen) {
          return Scaffold(
            body: Row(
              children: [
                AppSideNavigation(
                  selectedIndex: selectedIndex,
                  isExtended: isExtended,
                  onDestinationSelected: (index) => _onNavigate(context, index),
                  onToggleExtended: () {
                    setState(() {
                      _manuallyExpanded = !isExtended;
                    });
                  },
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.08),
                ),
                Expanded(
                  child: KeyedSubtree(key: _contentKey, child: widget.child),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: KeyedSubtree(key: _contentKey, child: widget.child),
            bottomNavigationBar: AppBottomNavigation(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => _onNavigate(context, index),
            ),
          );
        }
      },
    );
  }
}

/// Bottom navigation bar used on smaller/mobile devices.
class AppBottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = _getAppLocalizations(context);
    final navItems = appNavItems(l10n);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Semantics(
      label: l10n.main_app_nav,
      container: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: navItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == selectedIndex;

            return NavigationDestination(
              icon: Semantics(
                label:
                    '${item.semanticsLabel}, tab ${index + 1} of ${navItems.length}',
                selected: isSelected,
                button: true,
                child: Icon(item.icon),
              ),
              selectedIcon: Semantics(
                label:
                    '${item.semanticsLabel}, tab ${index + 1} of ${navItems.length}, selected',
                selected: isSelected,
                button: true,
                child: Icon(item.selectedIcon),
              ),
              label: item.label,
              tooltip: item.tooltip,
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Side navigation bar/rail used on large screens.
class AppSideNavigation extends ConsumerWidget {
  final int selectedIndex;
  final bool isExtended;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onToggleExtended;

  const AppSideNavigation({
    super.key,
    required this.selectedIndex,
    required this.isExtended,
    required this.onDestinationSelected,
    required this.onToggleExtended,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = _getAppLocalizations(context);
    final navItems = appNavItems(l10n);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navRailTheme = Theme.of(context).navigationRailTheme;
    final bgColor =
        navRailTheme.backgroundColor ??
        (isDark ? BrandColors.darkGrey : BrandColors.white);

    return Semantics(
      label: l10n.side_app_nav,
      container: true,
      child: Container(
        color: bgColor,
        width: isExtended ? 220 : 72,
        child: Column(
          children: [
            // Top brand header
            _buildBrandHeader(context),

            // Middle navigation rail
            Expanded(
              child: NavigationRail(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                extended: isExtended,
                // In Flutter, labelType must be none (or null) when extended is true
                labelType: isExtended
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
                minWidth: 72,
                minExtendedWidth: 220,
                backgroundColor: Colors.transparent,
                destinations: navItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == selectedIndex;

                  return NavigationRailDestination(
                    icon: Tooltip(
                      message: item.tooltip,
                      child: Semantics(
                        label:
                            '${item.semanticsLabel}, tab ${index + 1} of ${navItems.length}',
                        selected: isSelected,
                        button: true,
                        child: Icon(item.icon),
                      ),
                    ),
                    selectedIcon: Tooltip(
                      message: item.tooltip,
                      child: Semantics(
                        label:
                            '${item.semanticsLabel}, tab ${index + 1} of ${navItems.length}, selected',
                        selected: isSelected,
                        button: true,
                        child: Icon(item.selectedIcon),
                      ),
                    ),
                    label: Text(
                      item.label,
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  );
                }).toList(),
              ),
            ),

            // Bottom footer actions
            _buildFooter(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandHeader(BuildContext context) {
    final l10n = _getAppLocalizations(context);

    return Semantics(
      header: true,
      label: l10n.branding_heading,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Row(
          mainAxisAlignment: isExtended
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: BrandColors.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: BrandColors.primary,
                size: 22,
              ),
            ),
            if (isExtended) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Starter App',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'v1.0.0',
                      style: GoogleFonts.ibmPlexSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: BrandColors.neutral,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, WidgetRef ref) {
    final l10n = _getAppLocalizations(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Divider(
            height: 1,
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.08),
          ),
          const SizedBox(height: 8),
          // Theme toggle button
          Tooltip(
            message: isDark ? l10n.theme_switch_light : l10n.theme_switch_dark,
            child: Semantics(
              button: true,
              label: isDark ? l10n.theme_switch_light : l10n.theme_switch_dark,
              child: InkWell(
                onTap: () {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: isExtended
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      Icon(
                        isDark
                            ? Icons.light_mode_outlined
                            : Icons.dark_mode_outlined,
                        color: BrandColors.neutral,
                        size: 20,
                      ),
                      if (isExtended) ...[
                        const SizedBox(width: 12),
                        Text(
                          isDark ? l10n.light_mode : l10n.dark_mode,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: BrandColors.neutral,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          // Collapse / Expand toggle button
          Tooltip(
            message: isExtended ? l10n.collapse_sidebar : l10n.expand_sidebar,
            child: Semantics(
              button: true,
              label: isExtended ? l10n.collapse_side_nav : l10n.expand_side_nav,
              child: InkWell(
                onTap: onToggleExtended,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: isExtended
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.center,
                    children: [
                      Icon(
                        isExtended
                            ? Icons.keyboard_double_arrow_left_rounded
                            : Icons.keyboard_double_arrow_right_rounded,
                        color: BrandColors.neutral,
                        size: 20,
                      ),
                      if (isExtended) ...[
                        const SizedBox(width: 12),
                        Text(
                          l10n.collapse,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: BrandColors.neutral,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
