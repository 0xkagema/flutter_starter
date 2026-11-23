import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_starter/core/services/auth_service.dart';
import 'package:flutter_starter/extensions.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

/// Sets a new password after a forgot-password request. The user enters the
/// emailed reset code (or opens the link from the email) together with the new
/// password, then signs in again.
class ChangePasswordPage extends StatefulWidget {
  /// Email the reset code was sent to (used for the helper instructions).
  final String email;

  /// Number of digits in the reset code.
  final int digits;

  const ChangePasswordPage({this.email = '', this.digits = 6, super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscure = true;
  bool _isLoading = false;
  bool _isSuccess = false;
  int _seconds = 30;
  Timer? _timer;

  bool get _hasValidCode => _codeController.text.trim().length == widget.digits;
  bool get _hasLength => _passwordController.text.length >= 8;
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get _matches =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmController.text;
  bool get _valid => _hasValidCode && _hasLength && _hasNumber && _matches;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _seconds = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) {
        t.cancel();
      } else if (mounted) {
        setState(() => _seconds--);
      }
    });
  }

  Future<void> _resendCode() async {
    final l10n = _getAppLocalizations(context);
    if (widget.email.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      await AuthService.requestPasswordReset(widget.email);
      if (!mounted) return;
      _startTimer();
      context.showSuccessToast(l10n.reset_code_sent(widget.email));
    } catch (e) {
      if (mounted) context.showErrorToast(l10n.error_occurred(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _submit() async {
    final l10n = _getAppLocalizations(context);
    if (!_valid) return;

    setState(() => _isLoading = true);
    try {
      // TODO: Replace with the real verification step from your backend.
      // For Djoser, POST /auth/users/reset_password_confirm/ with the uid +
      // token decoded from the emailed link (or an OTP endpoint).
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      context.showSuccessToast(l10n.password_changed_success);
      setState(() => _isSuccess = true);
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
    final resendTime = '0:${_seconds.toString().padLeft(2, '0')}';

    final subtitle = widget.email.isEmpty
        ? l10n.new_password_instructions
        : l10n.change_password_subtitle('${widget.digits}', widget.email);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.change_password)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(560, 720)),
              padding: const EdgeInsets.all(24),
              child: _isSuccess
                  ? _buildSuccess(theme, scheme, l10n)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.password_rounded,
                          size: 56,
                          color: scheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.set_new_password,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          maxLength: widget.digits,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: l10n.reset_code,
                            hintText: l10n.reset_code_hint,
                            prefixIcon: const Icon(Icons.pin_outlined),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          obscureText: _obscure,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: l10n.new_password,
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmController,
                          obscureText: _obscure,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            labelText: l10n.confirm_password,
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _Rule(label: l10n.rule_min_chars, met: _hasLength),
                        _Rule(label: l10n.rule_has_number, met: _hasNumber),
                        _Rule(label: l10n.rule_passwords_match, met: _matches),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _seconds > 0
                                ? Text(
                                    l10n.resend_code_in(resendTime),
                                    style: TextStyle(
                                      color: scheme.onSurfaceVariant,
                                    ),
                                  )
                                : TextButton(
                                    onPressed: _isLoading ? null : _resendCode,
                                    child: Text(l10n.resend_code),
                                  ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: _valid && !_isLoading ? _submit : null,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.reset_password),
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

  Widget _buildSuccess(
    ThemeData theme,
    ColorScheme scheme,
    AppLocalizations l10n,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_rounded, size: 64, color: scheme.primary),
        const SizedBox(height: 16),
        Text(
          l10n.password_changed_success,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: () => context.go('/auth/sign-in'),
            child: Text(l10n.back_to_sign_in),
          ),
        ),
      ],
    );
  }
}

class _Rule extends StatelessWidget {
  final String label;
  final bool met;

  const _Rule({required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            size: 18,
            color: met ? Colors.green : scheme.outline,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: met ? scheme.onSurface : scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
