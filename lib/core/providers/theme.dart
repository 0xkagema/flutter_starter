import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final isDarkModeWithContextProvider = Provider.family<bool, BuildContext>((
  ref,
  context,
) {
  ref.watch(themeProvider);
  final themeNotifier = ref.read(themeProvider.notifier);
  return themeNotifier.isDarkMode(context);
});

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  bool isDarkMode(BuildContext context) {
    switch (state) {
      case ThemeMode.dark:
        return true;
      case ThemeMode.light:
        return false;
      case ThemeMode.system:
        return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await _saveTheme(themeMode);
  }

  Future<void> toggleTheme() async {
    ThemeMode newTheme;
    if (state == ThemeMode.dark) {
      newTheme = ThemeMode.light;
    } else {
      newTheme = ThemeMode.dark;
    }

    state = newTheme;
    await _saveTheme(newTheme);
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey);

      if (themeIndex != null) {
        state = ThemeMode.values[themeIndex];
      } else {}
    } catch (e) {
      state = ThemeMode.system;
    }
  }

  Future<void> _saveTheme(ThemeMode themeMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
    } catch (e) {
      // ignore
    }
  }
}

extension ThemeProviderExtension on WidgetRef {
  ThemeNotifier get themeNotifier => read(themeProvider.notifier);

  bool isDarkMode(BuildContext context) {
    watch(themeProvider);
    final themeNotifier = read(themeProvider.notifier);
    return themeNotifier.isDarkMode(context);
  }
}
