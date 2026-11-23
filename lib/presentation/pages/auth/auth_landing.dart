import 'package:material_ui/material_ui.dart';
import 'package:flutter_starter/extensions.dart';
import 'package:flutter_starter/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

AppLocalizations _getAppLocalizations(BuildContext context) {
  return AppLocalizations.of(context) ??
      lookupAppLocalizations(const Locale('en'));
}

/// Landing page shown to unauthenticated users. Acts as the gateway that
/// lets the user choose between signing in, creating an account, or using a
/// social provider.
class AuthLandingPage extends StatelessWidget {
  const AuthLandingPage({super.key});

  void _showComingSoon(BuildContext context) {
    final l10n = _getAppLocalizations(context);
    context.showInfoToast(l10n.feature_coming_soon);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = _getAppLocalizations(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Container(
                constraints: BoxConstraints.loose(const Size(600, 640)),
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_stories_rounded,
                      size: 72,
                      color: scheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.auth_welcome_heading,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.auth_welcome_subtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _SocialButton(
                      icon: const Icon(Icons.g_mobiledata_rounded, size: 26),
                      label: l10n.continue_with_google,
                      onPressed: () => _showComingSoon(context),
                    ),
                    const SizedBox(height: 12),
                    _SocialButton(
                      icon: const Icon(Icons.apple_rounded, size: 26),
                      label: l10n.continue_with_apple,
                      onPressed: () => _showComingSoon(context),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              l10n.auth_or,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: () => context.go('/auth/sign-in'),
                        child: Text(l10n.sign_in),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => context.go('/auth/sign-up'),
                        child: Text(l10n.create_account),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Text(label),
      ),
    );
  }
}
