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

  @override
  String get sign_out => 'Sign Out';

  @override
  String get sign_out_confirmation =>
      'Are you sure you want to sign out of your account?';

  @override
  String get cancel => 'Cancel';

  @override
  String get signout_success => 'Signed out successfully';

  @override
  String get starter_template_title => 'Flutter Starter Template';

  @override
  String get starter_template_subtitle =>
      'Responsive adaptive layout with declarative routing';

  @override
  String get starter_template_description =>
      'This starter template includes an adaptive navigation shell that seamlessly transitions between a side rail on desktop and a bottom navigation bar on mobile devices.';

  @override
  String get quick_navigation => 'Quick Navigation';

  @override
  String get quick_nav_books_description =>
      'Browse your reading collection and discover new titles.';

  @override
  String get quick_nav_profile_description =>
      'View your reading statistics and account information.';

  @override
  String get quick_nav_settings_description =>
      'Customize theme appearance and application preferences.';

  @override
  String get explore => 'Explore';

  @override
  String get your_reading_library => 'Your Reading Library';

  @override
  String get books_subtitle_description =>
      'Explore books, track reading milestones, and manage your collection.';

  @override
  String get category_all => 'All';

  @override
  String get engineering => 'Engineering';

  @override
  String get design => 'Design';

  @override
  String get product => 'Product';

  @override
  String get productivity => 'Productivity';

  @override
  String get status_completed => 'Completed';

  @override
  String get status_reading => 'Reading';

  @override
  String get status_wishlist => 'Wishlist';

  @override
  String add_to_favorites(Object title) {
    return 'Add $title to favorites';
  }

  @override
  String remove_from_favorites(Object title) {
    return 'Remove $title from favorites';
  }

  @override
  String get add_favorites_tooltip => 'Add to favorites';

  @override
  String get remove_favorites_tooltip => 'Remove from favorites';

  @override
  String get pro_member => 'Pro Member';

  @override
  String get books_read => 'Books Read';

  @override
  String get in_progress => 'In Progress';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get account_settings => 'Account Settings';

  @override
  String get personal_information => 'Personal Information';

  @override
  String get personal_information_subtitle => 'Update name, email, and phone';

  @override
  String get notification_preferences => 'Notification Preferences';

  @override
  String get notification_preferences_subtitle =>
      'Push, email, and digest options';

  @override
  String get security_password => 'Security & Password';

  @override
  String get security_password_subtitle => '2FA and login security';

  @override
  String get personal_info_up_to_date => 'Personal Info is up to date';

  @override
  String get notifications_configured => 'Notifications configured';

  @override
  String get security_settings_healthy => 'Security settings healthy';

  @override
  String get sign_out_account => 'Sign out of your account';

  @override
  String get verification => 'Verification';

  @override
  String get two_factor_auth => 'Two-factor authentication';

  @override
  String otp_code_sent_to(Object digits, Object phone) {
    return 'Enter the $digits-digit code sent to $phone';
  }

  @override
  String resend_code_in(Object time) {
    return 'Resend code in $time';
  }

  @override
  String get resend_code => 'Resend code';

  @override
  String get reset_password => 'Reset Password';

  @override
  String password_reset_email_sent(Object email) {
    return 'A password reset link has been sent to $email. Please check your email to reset your password.';
  }

  @override
  String get back_to_sign_in => 'Back to Sign In';

  @override
  String get password_reset_instructions =>
      'Enter your email address below and we will send you a link to reset your password.';

  @override
  String get email => 'Email';

  @override
  String get send_reset_link => 'Send Reset Link';

  @override
  String password_reset_requested(Object email) {
    return 'Password reset requested for email: $email';
  }

  @override
  String error_occurred(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get set_new_password => 'Set a new password';

  @override
  String get new_password_instructions =>
      'Your new password must be different from previously used passwords.';

  @override
  String get new_password => 'New password';

  @override
  String get confirm_password => 'Confirm password';

  @override
  String get rule_min_chars => 'At least 8 characters';

  @override
  String get rule_has_number => 'Contains a number';

  @override
  String get rule_passwords_match => 'Passwords match';

  @override
  String get sign_in => 'Sign in';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get forgot_password => 'Forgot Password?';

  @override
  String get signin_success => 'Signed in successfully';

  @override
  String get create_account => 'Create Account';

  @override
  String get get_started_free => 'Get started free';

  @override
  String get full_name => 'Full name';

  @override
  String password_strength(Object value) {
    return 'Strength: $value';
  }

  @override
  String get strength_too_weak => 'Too weak';

  @override
  String get strength_weak => 'Weak';

  @override
  String get strength_fair => 'Fair';

  @override
  String get strength_good => 'Good';

  @override
  String get strength_strong => 'Strong';

  @override
  String get agree_terms =>
      'I agree to the Terms of Service and Privacy Policy';

  @override
  String get toast_error_title => 'Error';

  @override
  String get toast_success_title => 'Success';

  @override
  String get toast_info_title => 'Info';

  @override
  String get toast_warning_title => 'Warning';
}
