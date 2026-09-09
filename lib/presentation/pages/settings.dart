import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/providers/locale.dart';
import '../../core/providers/theme.dart';
import '../../l10n/app_localizations.dart';
import '../theme/theme.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = Navigator.of(context).canPop();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        automaticallyImplyLeading: false,
        leading: canPop
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                tooltip: 'Back',
              )
            : null,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 680),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            children: [
              _SingleSection(
                title: "Appearance",
                children: [
                  _CustomListTile(
                    title: "Dark Mode",
                    icon: isDark
                        ? CupertinoIcons.moon_fill
                        : CupertinoIcons.moon,
                    trailing: Semantics(
                      label: 'Toggle dark mode',
                      toggled: themeMode == ThemeMode.dark,
                      child: CupertinoSwitch(
                        activeTrackColor: BrandColors.primary,
                        value: themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          ref.read(themeProvider.notifier).toggleTheme();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _SingleSection(
                title: l10n?.language ?? 'Language',
                children: [
                  _LanguageListTile(
                    locale: locale,
                    englishLabel: l10n?.english ?? 'English',
                    swahiliLabel: l10n?.swahili ?? 'Kiswahili',
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _SingleSection(
                title: "General",
                children: [
                  _CustomListTile(
                    title: "About Application",
                    icon: CupertinoIcons.info_circle,
                    onTap: () {
                      showAboutDialog(context: context);
                    },
                  ),
                  const _CustomListTile(
                    title: "System Updates",
                    icon: CupertinoIcons.cloud_download,
                  ),
                  const _CustomListTile(
                    title: "Security & Privacy",
                    icon: CupertinoIcons.lock_shield,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _SingleSection(
                title: "Support",
                children: [
                  const _CustomListTile(
                    title: "Help Center",
                    icon: CupertinoIcons.question_circle,
                  ),
                  const _CustomListTile(
                    title: "Send Feedback",
                    icon: CupertinoIcons.chat_bubble_2,
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

class _LanguageListTile extends ConsumerWidget {
  final Locale locale;
  final String englishLabel;
  final String swahiliLabel;

  const _LanguageListTile({
    required this.locale,
    required this.englishLabel,
    required this.swahiliLabel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageName = locale.languageCode == 'sw'
        ? swahiliLabel
        : englishLabel;

    return _CustomListTile(
      title: languageName,
      icon: CupertinoIcons.globe,
      trailing: PopupMenuButton<Locale>(
        tooltip: AppLocalizations.of(context)?.language ?? 'Language',
        onSelected: (value) {
          ref.read(localeProvider.notifier).setLocale(value);
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: const Locale('en'), child: Text(englishLabel)),
          PopupMenuItem(value: const Locale('sw'), child: Text(swahiliLabel)),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(languageName),
            const SizedBox(width: AppSpacing.xs),
            const Icon(CupertinoIcons.chevron_down, size: 16),
          ],
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  // callback function when tapped
  final VoidCallback? onTap;

  const _CustomListTile({
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.ibmPlexSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? BrandColors.white : BrandColors.darkGrey,
        ),
      ),
      leading: Icon(icon, color: BrandColors.primary, size: 22),
      trailing:
          trailing ??
          Icon(CupertinoIcons.forward, size: 18, color: BrandColors.neutral),
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SingleSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.ibmPlexSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
              color: BrandColors.neutral,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
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
          child: Column(children: children),
        ),
      ],
    );
  }
}
