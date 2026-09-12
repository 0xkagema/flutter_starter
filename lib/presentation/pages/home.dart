import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../l10n/app_localizations.dart';
import '../theme/theme.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = _getAppLocalizations(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.home)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            children: [
              // Welcome Banner Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  side: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : Colors.black.withValues(alpha: 0.08),
                  ),
                ),
                color: isDark ? BrandColors.darkGrey : BrandColors.white,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        BrandColors.primary.withValues(alpha: 0.12),
                        BrandColors.tertiary.withValues(
                          alpha: isDark ? 0.3 : 0.05,
                        ),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: BrandColors.primary,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: const Icon(
                              Icons.auto_stories_rounded,
                              color: BrandColors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.starter_template_title,
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? BrandColors.white
                                        : BrandColors.darkGrey,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l10n.starter_template_subtitle,
                                  style: GoogleFonts.ibmPlexSans(
                                    fontSize: 14,
                                    color: BrandColors.neutral,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        l10n.starter_template_description,
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 14,
                          height: 1.5,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Section header
              Semantics(
                header: true,
                child: Text(
                  l10n.quick_navigation,
                  style: GoogleFonts.ibmPlexSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? BrandColors.white : BrandColors.darkGrey,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Responsive quick navigation cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 720;

                  final cards = [
                    _QuickNavCard(
                      title: l10n.books,
                      description: l10n.quick_nav_books_description,
                      icon: Icons.menu_book_rounded,
                      color: BrandColors.primary,
                      onTap: () => context.go('/books'),
                    ),
                    _QuickNavCard(
                      title: l10n.profile,
                      description: l10n.quick_nav_profile_description,
                      icon: Icons.person_rounded,
                      color: BrandColors.secondary,
                      onTap: () => context.go('/profile'),
                    ),
                    _QuickNavCard(
                      title: l10n.settings,
                      description: l10n.quick_nav_settings_description,
                      icon: Icons.settings_rounded,
                      color: BrandColors.tertiary,
                      onTap: () => context.go('/settings'),
                    ),
                  ];

                  if (isWide) {
                    return Row(
                      children: cards
                          .map(
                            (card) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                ),
                                child: card,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }

                  return Column(
                    children: cards
                        .map(
                          (card) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            child: card,
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickNavCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickNavCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      color: isDark ? BrandColors.darkGrey : BrandColors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? BrandColors.white : BrandColors.darkGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: BrandColors.neutral,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Text(
                    _getAppLocalizations(context).explore,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: BrandColors.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: BrandColors.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
