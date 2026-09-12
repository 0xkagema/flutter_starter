import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

class SignupCredentials {
  final String password;
  final String email;

  SignupCredentials(this.email, this.password);
}

class SignUpPage extends StatefulWidget {
  final ValueChanged<SignupCredentials> onSignUp;
  const SignUpPage({required this.onSignUp, super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _password = '';

  bool _agreed = false;

  int get _strength {
    var score = 0;
    if (_password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(_password)) score++;
    if (RegExp(r'[0-9]').hasMatch(_password)) score++;
    if (RegExp(r'[!@#$%^&*]').hasMatch(_password)) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = _getAppLocalizations(context);
    final labels = [
      l10n.strength_too_weak,
      l10n.strength_weak,
      l10n.strength_fair,
      l10n.strength_good,
      l10n.strength_strong,
    ];
    final colors = [
      scheme.error,
      scheme.error,
      Colors.orange,
      Colors.amber,
      Colors.green,
    ];
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.get_started_free,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: l10n.full_name,
              prefixIcon: const Icon(Icons.person_outline),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: l10n.email,
              prefixIcon: const Icon(Icons.mail_outline),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            obscureText: true,
            onChanged: (v) => setState(() => _password = v),
            decoration: InputDecoration(
              labelText: l10n.password,
              prefixIcon: const Icon(Icons.lock_outline),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(4, (i) {
              final active = i < _strength;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(right: i < 3 ? 6 : 0),
                  decoration: BoxDecoration(
                    color: active
                        ? colors[_strength]
                        : scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.password_strength(labels[_strength]),
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _agreed,
            onChanged: (v) => setState(() => _agreed = v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.agree_terms),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 52,
            child: FilledButton(
              onPressed: _agreed
                  ? () {
                      //TODO: Implement sign up logic here
                      context.go('/2fa');
                    }
                  : null,
              child: Text(l10n.create_account),
            ),
          ),
        ],
      ),
      appBar: AppBar(title: Text(l10n.create_account)),
    );
  }
}
