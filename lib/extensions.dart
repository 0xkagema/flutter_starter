import 'package:flutter/widgets.dart';
import 'package:toastification/toastification.dart';

import 'l10n/app_localizations.dart';

extension ShowToast on BuildContext {
  void showErrorToast(String message, {String? title, Duration? duration}) {
    final l10n = AppLocalizations.of(this);
    toastification.show(
      title: Text(title ?? l10n?.toast_error_title ?? 'Error'),
      description: Text(message),
      type: ToastificationType.error,
      animationDuration: duration,
    );
  }

  void showSuccessToast(String message, {String? title, Duration? duration}) {
    final l10n = AppLocalizations.of(this);
    toastification.show(
      title: Text(title ?? l10n?.toast_success_title ?? 'Success'),
      description: Text(message),
      type: ToastificationType.success,
      animationDuration: duration,
    );
  }

  void showInfoToast(String message, {String? title, Duration? duration}) {
    final l10n = AppLocalizations.of(this);
    toastification.show(
      title: Text(title ?? l10n?.toast_info_title ?? 'Info'),
      description: Text(message),
      type: ToastificationType.info,
      animationDuration: duration,
    );
  }

  void showWarningToast(String message, {String? title, Duration? duration}) {
    final l10n = AppLocalizations.of(this);
    toastification.show(
      title: Text(title ?? l10n?.toast_warning_title ?? 'Warning'),
      description: Text(message),
      type: ToastificationType.warning,
      animationDuration: duration,
    );
  }
}
