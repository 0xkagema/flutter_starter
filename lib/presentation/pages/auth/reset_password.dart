import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  String _password = '';
  String _confirm = '';
  bool _obscure = true;

  bool get _hasLength => _password.length >= 8;
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_password);
  bool get _matches => _password.isNotEmpty && _password == _confirm;
  bool get _valid => _hasLength && _hasNumber && _matches;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = _getAppLocalizations(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reset_password)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.set_new_password,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.new_password_instructions,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            obscureText: _obscure,
            onChanged: (v) => setState(() => _password = v),
            decoration: InputDecoration(
              labelText: l10n.new_password,
              prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: _obscure,
            onChanged: (v) => setState(() => _confirm = v),
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
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _valid ? () {} : null,
              child: Text(l10n.reset_password),
            ),
          ),
        ],
      ),
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
