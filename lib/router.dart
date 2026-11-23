import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers/auth.dart';
import 'extensions.dart';
import 'l10n/app_localizations.dart';
import 'presentation/pages/auth/auth_landing.dart';
import 'presentation/pages/auth/change_password.dart';
import 'presentation/pages/auth/forgot_password.dart';
import 'presentation/pages/auth/otp.dart';
import 'presentation/pages/auth/sign_in.dart';
import 'presentation/pages/auth/sign_up.dart';
import 'presentation/pages/books.dart';
import 'presentation/pages/home.dart';
import 'presentation/pages/interstitial.dart';
import 'presentation/pages/profile.dart';
import 'presentation/pages/settings.dart';
import 'presentation/widgets/fade_transition_page.dart';
import 'presentation/widgets/nav.dart';

/// Paths that stay accessible while the user is not authenticated.
const List<String> _publicAuthPaths = [
  '/interstitial',
  '/auth',
  '/auth/sign-in',
  '/auth/sign-up',
  '/auth/verify',
  '/auth/forgot-password',
  '/auth/change-password',
];

bool _isPublicAuthPath(String path) => _publicAuthPaths.contains(path);

@visibleForTesting
String? authRedirect(AsyncValue<bool> authState, String path) {
  if (authState.isLoading || authState.hasError) {
    return path == '/interstitial' ? null : '/interstitial';
  }

  final signedIn = authState.requireValue;

  if (path == '/interstitial') {
    return signedIn ? '/' : '/auth';
  }

  if (!signedIn && !_isPublicAuthPath(path)) {
    return '/auth';
  }

  return null;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshProvider);

  return GoRouter(
    initialLocation: '/interstitial',

    refreshListenable: refreshNotifier,

    redirect: (context, state) {
      final authState = ref.read(authProvider);
      return authRedirect(authState, state.uri.path);
    },

    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthLandingPage(),
      ),
      GoRoute(
        path: '/auth/sign-in',
        builder: (context, state) {
          // Use a builder to get the correct BuildContext
          return Builder(
            builder: (context) {
              return SignInScreen(
                onSignIn: (value) async {
                  try {
                    final router = GoRouter.of(context);
                    await ref
                        .read(authProvider.notifier)
                        .signIn(value.username, value.password);
                    router.go('/');
                    // Show a success toast after successful sign-in
                    if (context.mounted) {
                      final l10n = AppLocalizations.of(context);
                      context.showSuccessToast(
                        l10n?.signin_success ?? 'Signed in successfully',
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      context.showErrorToast(e.toString());
                    }
                  }
                },
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/auth/sign-up',
        builder: (context, state) {
          // Use a builder to get the correct BuildContext
          return Builder(
            builder: (context) {
              return SignUpPage(
                onSignUp: (value) async {
                  final router = GoRouter.of(context);
                  await ref
                      .read(authProvider.notifier)
                      .signUp(
                        username: value.username,
                        email: value.email,
                        password: value.password,
                        fullName: value.fullName,
                      );
                  // Auto sign-in after registration so the session is active.
                  await ref
                      .read(authProvider.notifier)
                      .signIn(value.username, value.password);
                  // Optionally verify the account via OTP before entering the app.
                  router.go(
                    '/auth/verify?email='
                    '${Uri.encodeQueryComponent(value.email)}',
                  );
                },
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/auth/verify',
        builder: (context, state) {
          final params = state.uri.queryParameters;
          final email = params['email'];
          final digits = int.tryParse(params['digits'] ?? '') ?? 6;

          return OtpPage(
            email: email,
            digits: digits,
            onVerified: () {
              if (context.mounted) context.go('/');
            },
            onSkip: () {
              if (context.mounted) context.go('/');
            },
          );
        },
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/auth/change-password',
        builder: (context, state) {
          // Optionally carries the email the reset was requested for.
          final email = state.uri.queryParameters['email'] ?? '';
          return ChangePasswordPage(email: email);
        },
      ),
      GoRoute(
        path: '/interstitial',
        builder: (context, state) => const InterstitialPage(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return AppBaseLayout(currentPath: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                FadeTransitionPage(key: state.pageKey, child: const HomePage()),
          ),
          GoRoute(
            path: '/books',
            pageBuilder: (context, state) => FadeTransitionPage(
              key: state.pageKey,
              child: const BooksPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => FadeTransitionPage(
              key: state.pageKey,
              child: const ProfilePage(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => FadeTransitionPage(
              key: state.pageKey,
              child: const SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
});
