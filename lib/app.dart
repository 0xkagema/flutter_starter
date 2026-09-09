import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/providers/locale.dart';
import 'core/providers/theme.dart';
import 'l10n/app_localizations.dart';
import 'presentation/theme/theme.dart';
import 'router.dart';

final appShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'app shell');

class Application extends ConsumerWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      theme: AppTheme.lightTheme.copyWith(
        extensions: [AppThemeExtension.light],
      ),

      darkTheme: AppTheme.darkTheme.copyWith(
        extensions: [AppThemeExtension.dark],
      ),

      themeMode: themeMode,

      locale: locale,

      routerConfig: router,

      // localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: supportedLocales,
    );
  }
}
