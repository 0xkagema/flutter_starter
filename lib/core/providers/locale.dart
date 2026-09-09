import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

const supportedLocales = [Locale('en'), Locale('sw')];

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  static const String _localeKey = 'app_locale';

  LocaleNotifier() : super(supportedLocales.first) {
    _loadLocale();
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) return;

    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);

    if (languageCode == null) return;

    final savedLocale = Locale(languageCode);
    if (supportedLocales.contains(savedLocale)) {
      state = savedLocale;
    }
  }
}
