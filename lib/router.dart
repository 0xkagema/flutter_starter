import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/providers/auth.dart';
import 'extensions.dart';
import 'presentation/pages/auth/otp.dart';
import 'presentation/pages/auth/reset_password.dart';
import 'presentation/pages/auth/sign_in.dart';
import 'presentation/pages/auth/sign_up.dart';
import 'presentation/pages/home.dart';
import 'presentation/pages/interstitial.dart';
import 'presentation/pages/settings.dart';
import 'presentation/widgets/fade_transition_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = ref.watch(routerRefreshProvider);

  return GoRouter(
    initialLocation: '/interstitial',

    refreshListenable: refreshNotifier,

    redirect: (context, state) {
      final signedIn = ref.read(authProvider);

      if (!signedIn &&
          state.uri.path != '/sign-in' &&
          state.uri.path != '/sign-up' &&
          state.uri.path != '/reset-password') {
        return '/sign-in';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/sign-in',
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
                    context.showSuccessToast('Signed in successfully');
                  } catch (e) {
                    context.showErrorToast(e.toString());
                  }
                },
              );
            },
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) {
          // Use a builder to get the correct BuildContext
          return Builder(
            builder: (context) {
              return SignUpPage(
                onSignUp: (value) async {
                  final router = GoRouter.of(context);
                  await ref
                      .read(authProvider.notifier)
                      .signIn(value.email, value.password);
                  router.go('/');
                },
              );
            },
          );
        },
      ),
      GoRoute(path: '/2fa', builder: (context, state) => const OtpPage()),

      GoRoute(
        path: '/interstitial',
        builder: (context, state) => const InterstitialPage(),
      ),

      ShellRoute(
        pageBuilder: (context, state, child) {
          return FadeTransitionPage(key: state.pageKey, child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
});
