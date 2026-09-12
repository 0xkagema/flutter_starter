// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get hello => 'Hello';

  @override
  String greetUser(Object username) {
    return 'Welcome, $username!';
  }

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get swahili => 'Kiswahili';

  @override
  String get home => 'Home';

  @override
  String get navigate_home => 'Navigate to Home';

  @override
  String get home_tab => 'Home Tab';

  @override
  String get books => 'Books';

  @override
  String get navigate_books => 'Navigate to Books';

  @override
  String get books_tab => 'Books Tab';

  @override
  String get settings => 'Settings';

  @override
  String get navigate_settings => 'Navigate to Settings';

  @override
  String get settings_tab => 'Settings Tab';

  @override
  String get profile => 'Profile';

  @override
  String get navigate_profile => 'Navigate to Profile';

  @override
  String get profile_tab => 'Profile Tab';

  @override
  String get main_app_nav => 'Main App Navigation';

  @override
  String get side_app_nav => 'Main application side navigation';

  @override
  String get branding_heading => 'Flutter Starter brand heading';

  @override
  String get theme_switch_light => 'Switch to Light appearance mode';

  @override
  String get theme_switch_dark => 'Switch to Dark appearance mode';

  @override
  String get light_mode => 'Light Mode';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get collapse_sidebar => 'Collapse Sidebar';

  @override
  String get expand_sidebar => 'Expand Sidebar';

  @override
  String get collapse_side_nav => 'Collapse Side Navigation';

  @override
  String get expand_side_nav => 'Expand Side Navigation';

  @override
  String get collapse => 'Collapse';

  @override
  String get back => 'Back';

  @override
  String get appearance => 'Appearance';

  @override
  String get toggle_dark_mode => 'Toggle Dark Mode';

  @override
  String get general => 'General';

  @override
  String get about_application => 'About Application';

  @override
  String get system_update => 'System Updates';

  @override
  String get security_privacy => 'Security & Privacy';

  @override
  String get support => 'Support';

  @override
  String get help_center => 'Help Center';

  @override
  String get send_feedback => 'Send Feedback';
}
