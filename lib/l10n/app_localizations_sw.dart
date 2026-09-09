// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swahili (`sw`).
class AppLocalizationsSw extends AppLocalizations {
  AppLocalizationsSw([String locale = 'sw']) : super(locale);

  @override
  String get hello => 'Habari';

  @override
  String greetUser(Object username) {
    return 'Karibu, $username!';
  }

  @override
  String get language => 'Lugha';

  @override
  String get english => 'Kiingereza';

  @override
  String get swahili => 'Kiswahili';
}
