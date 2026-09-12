import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_sw.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('sw'),
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// No description provided for @greetUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {username}!'**
  String greetUser(Object username);

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @swahili.
  ///
  /// In en, this message translates to:
  /// **'Kiswahili'**
  String get swahili;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @navigate_home.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Home'**
  String get navigate_home;

  /// No description provided for @home_tab.
  ///
  /// In en, this message translates to:
  /// **'Home Tab'**
  String get home_tab;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @navigate_books.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Books'**
  String get navigate_books;

  /// No description provided for @books_tab.
  ///
  /// In en, this message translates to:
  /// **'Books Tab'**
  String get books_tab;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @navigate_settings.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Settings'**
  String get navigate_settings;

  /// No description provided for @settings_tab.
  ///
  /// In en, this message translates to:
  /// **'Settings Tab'**
  String get settings_tab;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @navigate_profile.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Profile'**
  String get navigate_profile;

  /// No description provided for @profile_tab.
  ///
  /// In en, this message translates to:
  /// **'Profile Tab'**
  String get profile_tab;

  /// No description provided for @main_app_nav.
  ///
  /// In en, this message translates to:
  /// **'Main App Navigation'**
  String get main_app_nav;

  /// No description provided for @side_app_nav.
  ///
  /// In en, this message translates to:
  /// **'Main application side navigation'**
  String get side_app_nav;

  /// No description provided for @branding_heading.
  ///
  /// In en, this message translates to:
  /// **'Flutter Starter brand heading'**
  String get branding_heading;

  /// No description provided for @theme_switch_light.
  ///
  /// In en, this message translates to:
  /// **'Switch to Light appearance mode'**
  String get theme_switch_light;

  /// No description provided for @theme_switch_dark.
  ///
  /// In en, this message translates to:
  /// **'Switch to Dark appearance mode'**
  String get theme_switch_dark;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @collapse_sidebar.
  ///
  /// In en, this message translates to:
  /// **'Collapse Sidebar'**
  String get collapse_sidebar;

  /// No description provided for @expand_sidebar.
  ///
  /// In en, this message translates to:
  /// **'Expand Sidebar'**
  String get expand_sidebar;

  /// No description provided for @collapse_side_nav.
  ///
  /// In en, this message translates to:
  /// **'Collapse Side Navigation'**
  String get collapse_side_nav;

  /// No description provided for @expand_side_nav.
  ///
  /// In en, this message translates to:
  /// **'Expand Side Navigation'**
  String get expand_side_nav;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @toggle_dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Toggle Dark Mode'**
  String get toggle_dark_mode;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @about_application.
  ///
  /// In en, this message translates to:
  /// **'About Application'**
  String get about_application;

  /// No description provided for @system_update.
  ///
  /// In en, this message translates to:
  /// **'System Updates'**
  String get system_update;

  /// No description provided for @security_privacy.
  ///
  /// In en, this message translates to:
  /// **'Security & Privacy'**
  String get security_privacy;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @help_center.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get help_center;

  /// No description provided for @send_feedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get send_feedback;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'sw':
      return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
