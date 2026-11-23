import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

class SignupCredentials {
  final String username;
  final String fullName;
  final String email;
  final String password;

  SignupCredentials({
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
  });
}

class SignUpPage extends StatefulWidget {
  final ValueChanged<SignupCredentials> onSignUp;
  const SignUpPage({required this.onSignUp, super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _password = '';
  bool _agreed = false;
  bool _isLoading = false;

  int get _strength {
    var score = 0;
    if (_password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(_password)) score++;
    if (RegExp(r'[0-9]').hasMatch(_password)) score++;
    if (RegExp(r'[!@#$%^&*]').hasMatch(_password)) score++;
    return score;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    try {
      widget.onSignUp(
        SignupCredentials(
          username: _usernameController.text.trim(),
          fullName: _fullNameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: l10n.username,
              prefixIcon: const Icon(Icons.alternate_email_rounded),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _fullNameController,
            decoration: InputDecoration(
              labelText: l10n.full_name,
              prefixIcon: const Icon(Icons.person_outline),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.email,
              prefixIcon: const Icon(Icons.mail_outline),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
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
              onPressed: _agreed && !_isLoading ? _submit : null,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.create_account),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  l10n.auth_already_have_account,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/auth/sign-in'),
                child: Text(l10n.sign_in),
              ),
            ],
          ),
        ],
      ),
      appBar: AppBar(title: Text(l10n.create_account)),
    );
  }
}
