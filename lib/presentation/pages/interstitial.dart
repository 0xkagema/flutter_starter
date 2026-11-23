import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/auth.dart';
import '../../l10n/app_localizations.dart';

class InterstitialPage extends ConsumerWidget {
  const InterstitialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      body: Center(
        child: authState.when(
          data: (_) => const CircularProgressIndicator.adaptive(),
          loading: () => const CircularProgressIndicator.adaptive(),
          error: (error, _) => _SessionValidationError(
            error: error,
            onRetry: () =>
                ref.read(authProvider.notifier).retrySessionValidation(),
          ),
        ),
      ),
    );
  }
}

class _SessionValidationError extends StatelessWidget {
  const _SessionValidationError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_rounded, size: 48),
          const SizedBox(height: 16),
          Text(
            localizations.error_occurred(error.toString()),
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(localizations.retry_action),
          ),
        ],
      ),
    );
  }
}
