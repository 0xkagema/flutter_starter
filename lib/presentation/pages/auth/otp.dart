import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_starter/extensions.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

class OtpPage extends StatefulWidget {
  /// Email (or phone) the code was sent to; used in the helper text.
  final String? email;

  /// Number of digits in the verification code.
  final int digits;

  /// Invoked once the user verifies a complete code.
  final VoidCallback? onVerified;

  /// Invoked when the user opts out of two-factor verification.
  final VoidCallback? onSkip;

  const OtpPage({
    this.email,
    this.digits = 6,
    this.onVerified,
    this.onSkip,
    super.key,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _Keypad extends StatelessWidget {
  final void Function(String) onTap;
  final VoidCallback onBackspace;
  const _Keypad({required this.onTap, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        childAspectRatio: 1.8,
        physics: const NeverScrollableScrollPhysics(),
        children: keys.map((k) {
          if (k.isEmpty) return const SizedBox();
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => k == '⌫' ? onBackspace() : onTap(k),
            child: Center(
              child: k == '⌫'
                  ? const Icon(Icons.backspace_outlined)
                  : Text(k, style: Theme.of(context).textTheme.headlineSmall),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OtpPageState extends State<OtpPage> {
  String _code = '';
  int _seconds = 30;
  Timer? _timer;
  bool _isVerifying = false;

  bool get _isComplete => _code.length == widget.digits;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = _getAppLocalizations(context);
    final resendTime = '0:${_seconds.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.verification)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 56,
                  color: scheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.two_factor_auth,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.otp_code_sent_to_email(
                    '${widget.digits}',
                    widget.email ?? '••••',
                  ),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.digits, (i) {
                    final filled = i < _code.length;
                    return Container(
                      width: 44,
                      height: 54,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: filled
                              ? scheme.primary
                              : scheme.outlineVariant,
                          width: filled ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        filled ? _code[i] : '',
                        style: theme.textTheme.headlineSmall,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                _seconds > 0
                    ? Text(
                        l10n.resend_code_in(resendTime),
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      )
                    : TextButton(
                        onPressed: _startTimer,
                        child: Text(l10n.resend_code),
                      ),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: _Keypad(onTap: _tap, onBackspace: _back),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton(
                          onPressed: _isComplete && !_isVerifying
                              ? _verify
                              : null,
                          child: _isVerifying
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.otp_verify),
                        ),
                      ),
                      if (widget.onSkip != null)
                        TextButton(
                          onPressed: widget.onSkip,
                          child: Text(l10n.otp_skip),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Verifies the entered code against the backend, then fires [widget.onVerified].
  Future<void> _verify() async {
    final l10n = _getAppLocalizations(context);
    setState(() => _isVerifying = true);
    try {
      // TODO: Replace with your real OTP verification endpoint. Until then we
      // simulate the network round-trip.
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      context.showSuccessToast(l10n.otp_verified_success);
      widget.onVerified?.call();
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _back() {
    if (_code.isNotEmpty) {
      setState(() => _code = _code.substring(0, _code.length - 1));
    }
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

  void _tap(String d) {
    if (_code.length < widget.digits) setState(() => _code += d);
  }
}
