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

  /// No description provided for @sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get sign_out;

  /// No description provided for @sign_out_confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out of your account?'**
  String get sign_out_confirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @signout_success.
  ///
  /// In en, this message translates to:
  /// **'Signed out successfully'**
  String get signout_success;

  /// No description provided for @starter_template_title.
  ///
  /// In en, this message translates to:
  /// **'Flutter Starter Template'**
  String get starter_template_title;

  /// No description provided for @starter_template_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Responsive adaptive layout with declarative routing'**
  String get starter_template_subtitle;

  /// No description provided for @starter_template_description.
  ///
  /// In en, this message translates to:
  /// **'This starter template includes an adaptive navigation shell that seamlessly transitions between a side rail on desktop and a bottom navigation bar on mobile devices.'**
  String get starter_template_description;

  /// No description provided for @quick_navigation.
  ///
  /// In en, this message translates to:
  /// **'Quick Navigation'**
  String get quick_navigation;

  /// No description provided for @quick_nav_books_description.
  ///
  /// In en, this message translates to:
  /// **'Browse your reading collection and discover new titles.'**
  String get quick_nav_books_description;

  /// No description provided for @quick_nav_profile_description.
  ///
  /// In en, this message translates to:
  /// **'View your reading statistics and account information.'**
  String get quick_nav_profile_description;

  /// No description provided for @quick_nav_settings_description.
  ///
  /// In en, this message translates to:
  /// **'Customize theme appearance and application preferences.'**
  String get quick_nav_settings_description;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @your_reading_library.
  ///
  /// In en, this message translates to:
  /// **'Your Reading Library'**
  String get your_reading_library;

  /// No description provided for @books_subtitle_description.
  ///
  /// In en, this message translates to:
  /// **'Explore books, track reading milestones, and manage your collection.'**
  String get books_subtitle_description;

  /// No description provided for @category_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get category_all;

  /// No description provided for @engineering.
  ///
  /// In en, this message translates to:
  /// **'Engineering'**
  String get engineering;

  /// No description provided for @design.
  ///
  /// In en, this message translates to:
  /// **'Design'**
  String get design;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @productivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get productivity;

  /// No description provided for @status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get status_completed;

  /// No description provided for @status_reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get status_reading;

  /// No description provided for @status_wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get status_wishlist;

  /// No description provided for @add_to_favorites.
  ///
  /// In en, this message translates to:
  /// **'Add {title} to favorites'**
  String add_to_favorites(Object title);

  /// No description provided for @remove_from_favorites.
  ///
  /// In en, this message translates to:
  /// **'Remove {title} from favorites'**
  String remove_from_favorites(Object title);

  /// No description provided for @add_favorites_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get add_favorites_tooltip;

  /// No description provided for @remove_favorites_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get remove_favorites_tooltip;

  /// No description provided for @pro_member.
  ///
  /// In en, this message translates to:
  /// **'Pro Member'**
  String get pro_member;

  /// No description provided for @books_read.
  ///
  /// In en, this message translates to:
  /// **'Books Read'**
  String get books_read;

  /// No description provided for @in_progress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get in_progress;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @account_settings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get account_settings;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @personal_information_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Update name, email, and phone'**
  String get personal_information_subtitle;

  /// No description provided for @notification_preferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notification_preferences;

  /// No description provided for @notification_preferences_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Push, email, and digest options'**
  String get notification_preferences_subtitle;

  /// No description provided for @security_password.
  ///
  /// In en, this message translates to:
  /// **'Security & Password'**
  String get security_password;

  /// No description provided for @security_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'2FA and login security'**
  String get security_password_subtitle;

  /// No description provided for @personal_info_up_to_date.
  ///
  /// In en, this message translates to:
  /// **'Personal Info is up to date'**
  String get personal_info_up_to_date;

  /// No description provided for @notifications_configured.
  ///
  /// In en, this message translates to:
  /// **'Notifications configured'**
  String get notifications_configured;

  /// No description provided for @security_settings_healthy.
  ///
  /// In en, this message translates to:
  /// **'Security settings healthy'**
  String get security_settings_healthy;

  /// No description provided for @sign_out_account.
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account'**
  String get sign_out_account;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @two_factor_auth.
  ///
  /// In en, this message translates to:
  /// **'Two-factor authentication'**
  String get two_factor_auth;

  /// No description provided for @otp_code_sent_to.
  ///
  /// In en, this message translates to:
  /// **'Enter the {digits}-digit code sent to {phone}'**
  String otp_code_sent_to(Object digits, Object phone);

  /// No description provided for @resend_code_in.
  ///
  /// In en, this message translates to:
  /// **'Resend code in {time}'**
  String resend_code_in(Object time);

  /// No description provided for @resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resend_code;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @password_reset_email_sent.
  ///
  /// In en, this message translates to:
  /// **'A password reset link has been sent to {email}. Please check your email to reset your password.'**
  String password_reset_email_sent(Object email);

  /// No description provided for @back_to_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get back_to_sign_in;

  /// No description provided for @password_reset_instructions.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address below and we will send you a link to reset your password.'**
  String get password_reset_instructions;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @send_reset_link.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get send_reset_link;

  /// No description provided for @password_reset_requested.
  ///
  /// In en, this message translates to:
  /// **'Password reset requested for email: {email}'**
  String password_reset_requested(Object email);

  /// No description provided for @error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String error_occurred(Object error);

  /// No description provided for @set_new_password.
  ///
  /// In en, this message translates to:
  /// **'Set a new password'**
  String get set_new_password;

  /// No description provided for @new_password_instructions.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be different from previously used passwords.'**
  String get new_password_instructions;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get new_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirm_password;

  /// No description provided for @rule_min_chars.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get rule_min_chars;

  /// No description provided for @rule_has_number.
  ///
  /// In en, this message translates to:
  /// **'Contains a number'**
  String get rule_has_number;

  /// No description provided for @rule_passwords_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords match'**
  String get rule_passwords_match;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get sign_in;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgot_password;

  /// No description provided for @signin_success.
  ///
  /// In en, this message translates to:
  /// **'Signed in successfully'**
  String get signin_success;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @get_started_free.
  ///
  /// In en, this message translates to:
  /// **'Get started free'**
  String get get_started_free;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get full_name;

  /// No description provided for @password_strength.
  ///
  /// In en, this message translates to:
  /// **'Strength: {value}'**
  String password_strength(Object value);

  /// No description provided for @strength_too_weak.
  ///
  /// In en, this message translates to:
  /// **'Too weak'**
  String get strength_too_weak;

  /// No description provided for @strength_weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get strength_weak;

  /// No description provided for @strength_fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get strength_fair;

  /// No description provided for @strength_good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get strength_good;

  /// No description provided for @strength_strong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strength_strong;

  /// No description provided for @agree_terms.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service and Privacy Policy'**
  String get agree_terms;

  /// No description provided for @toast_error_title.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get toast_error_title;

  /// No description provided for @toast_success_title.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get toast_success_title;

  /// No description provided for @toast_info_title.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get toast_info_title;

  /// No description provided for @toast_warning_title.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get toast_warning_title;
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
