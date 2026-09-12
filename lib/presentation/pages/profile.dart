import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/providers/auth.dart';
import '../../extensions.dart';
import '../theme/theme.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = _getAppLocalizations(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.sign_out),
          content: Text(l10n.sign_out_confirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColors.danger,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(l10n.sign_out),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) {
        context.showInfoToast(l10n.signout_success);
        context.go('/sign-in');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = _getAppLocalizations(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            children: [
              // User header card
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
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: BrandColors.primary.withValues(alpha: 0.15),
                          border: Border.all(
                            color: BrandColors.primary,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person_rounded,
                            size: 44,
                            color: BrandColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Jane Doe',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? BrandColors.white
                              : BrandColors.darkGrey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'jane.doe@example.com',
                        style: GoogleFonts.ibmPlexSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: BrandColors.neutral,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: BrandColors.success.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(AppRadius.xxl),
                        ),
                        child: Text(
                          l10n.pro_member,
                          style: GoogleFonts.ibmPlexSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: BrandColors.success,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Stats Row
                      Divider(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.08),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem(context, '12', l10n.books_read),
                          _buildDivider(isDark),
                          _buildStatItem(context, '3', l10n.in_progress),
                          _buildDivider(isDark),
                          _buildStatItem(context, '8', l10n.wishlist),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Settings and preferences section
              Text(
                l10n.account_settings.toUpperCase(),
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: BrandColors.neutral,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              Card(
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
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.badge_outlined),
                      title: Text(l10n.personal_information),
                      subtitle: Text(l10n.personal_information_subtitle),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        context.showInfoToast(l10n.personal_info_up_to_date);
                      },
                    ),
                    Divider(
                      height: 1,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                    ListTile(
                      leading: const Icon(Icons.notifications_outlined),
                      title: Text(l10n.notification_preferences),
                      subtitle: Text(l10n.notification_preferences_subtitle),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        context.showInfoToast(l10n.notifications_configured);
                      },
                    ),
                    Divider(
                      height: 1,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                    ListTile(
                      leading: const Icon(Icons.security_outlined),
                      title: Text(l10n.security_password),
                      subtitle: Text(l10n.security_password_subtitle),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        context.showInfoToast(l10n.security_settings_healthy);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Sign Out Button
              Semantics(
                button: true,
                label: l10n.sign_out_account,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: BrandColors.danger,
                    side: const BorderSide(color: BrandColors.danger),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  onPressed: () => _handleSignOut(context, ref),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: BrandColors.danger,
                  ),
                  label: Text(
                    l10n.sign_out,
                    style: GoogleFonts.ibmPlexSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: BrandColors.danger,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? BrandColors.white : BrandColors.darkGrey,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.ibmPlexSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: BrandColors.neutral,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 30,
      color: isDark
          ? Colors.white.withValues(alpha: 0.08)
          : Colors.black.withValues(alpha: 0.08),
    );
  }
}
