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

  @override
  String get home => 'Nyumbani';

  @override
  String get navigate_home => 'Nenda Nyumbani';

  @override
  String get home_tab => 'Kipengele cha Nyumbani';

  @override
  String get books => 'Vitabu';

  @override
  String get navigate_books => 'Nenda Kwa Vitabu';

  @override
  String get books_tab => 'Kipengele cha Vitabu';

  @override
  String get settings => 'Mipangilio';

  @override
  String get navigate_settings => 'Nenda Kwa Mipangilio';

  @override
  String get settings_tab => 'Kipengele cha Mipangilio';

  @override
  String get profile => 'Wasifu';

  @override
  String get navigate_profile => 'Nenda Kwa Wasifu';

  @override
  String get profile_tab => 'Kipengele cha Wasifu';

  @override
  String get main_app_nav => 'Urambazaji wa Programu';

  @override
  String get side_app_nav => 'Urambazaji wa upande wa programu';

  @override
  String get branding_heading => 'Kichwa cha chapa ya Flutter Starter';

  @override
  String get theme_switch_light => 'Badilisha kwa hali ya mwangaza';

  @override
  String get theme_switch_dark => 'Badilisha kwa hali ya giza';

  @override
  String get light_mode => 'Hali ya Mwangaza';

  @override
  String get dark_mode => 'Hali ya Giza';

  @override
  String get collapse_sidebar => 'Punguza Upande wa Upande';

  @override
  String get expand_sidebar => 'Panua Upande wa Upande';

  @override
  String get collapse_side_nav => 'Punguza Urambazaji wa Upande';

  @override
  String get expand_side_nav => 'Panua Urambazaji wa Upande';

  @override
  String get collapse => 'Punguza';
}
