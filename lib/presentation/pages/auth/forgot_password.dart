import 'package:material_ui/material_ui.dart';
import 'package:flutter_starter/core/services/auth_service.dart';
import 'package:flutter_starter/extensions.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

/// Enter the account email to request a password reset. Sends a reset code
/// and link, then hands off to [ChangePasswordPage] where the user enters the
/// code (or clicks the emailed link) and picks a new password.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool get _isValidEmail => RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  ).hasMatch(_emailController.text.trim());

  Future<void> _sendResetCode() async {
    final l10n = _getAppLocalizations(context);
    final email = _emailController.text.trim();
    if (!_isValidEmail) {
      context.showWarningToast(l10n.email);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthService.requestPasswordReset(email);
      if (!mounted) return;
      context.showSuccessToast(l10n.reset_code_sent(email));
      context.go(
        '/auth/change-password?email=${Uri.encodeQueryComponent(email)}',
      );
    } catch (e) {
      if (mounted) context.showErrorToast(l10n.error_occurred(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = _getAppLocalizations(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgot_password)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(560, 560)),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lock_reset_rounded,
                    size: 56,
                    color: scheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.reset_password,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.forgot_password_instructions,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: l10n.email,
                      prefixIcon: const Icon(Icons.mail_outline),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _sendResetCode,
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.send_reset_code),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.go('/auth/sign-in'),
                      child: Text(l10n.back_to_sign_in),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
