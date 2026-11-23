import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter/core/http/client.dart';
import 'package:flutter_starter/core/providers/auth.dart';
import 'package:flutter_starter/core/repositories/auth_repository.dart';
import 'package:flutter_starter/router.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthNotifier', () {
    test(
      'does not contact the backend when no stored session exists',
      () async {
        final repository = _FakeAuthRepository(hasSession: false);
        final container = _createContainer(repository);
        addTearDown(container.dispose);

        expect(await container.read(authProvider.future), isFalse);
        expect(repository.validationCount, isZero);
      },
    );

    test('validates a stored session against the backend', () async {
      final repository = _FakeAuthRepository(hasSession: true);
      final container = _createContainer(repository);
      addTearDown(container.dispose);

      expect(await container.read(authProvider.future), isTrue);
      expect(repository.validationCount, 1);
    });

    test('clears an unauthorized stored session', () async {
      final repository = _FakeAuthRepository(
        hasSession: true,
        validationError: const UnauthorizedException('Expired session'),
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);

      expect(await container.read(authProvider.future), isFalse);
      expect(repository.signOutCount, 1);
    });

    test('exposes network failures so the UI can offer retry', () async {
      final repository = _FakeAuthRepository(
        hasSession: true,
        validationError: const NetworkException('Backend unavailable'),
      );
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final errorCompleter = Completer<Object>();
      final subscription = container.listen(authProvider, (_, next) {
        if (next case AsyncError(:final error)) {
          errorCompleter.complete(error);
        }
      });
      addTearDown(subscription.close);

      expect(await errorCompleter.future, isA<NetworkException>());
      expect(container.read(authProvider).hasError, isTrue);
    });

    test('reacts when the HTTP client invalidates the session', () async {
      final repository = _FakeAuthRepository(hasSession: true);
      final container = _createContainer(repository);
      addTearDown(container.dispose);
      final subscription = container.listen(authProvider, (_, _) {});
      addTearDown(subscription.close);

      expect(await container.read(authProvider.future), isTrue);

      repository.notifyUnauthenticated();

      expect(container.read(authProvider).requireValue, isFalse);
    });
  });

  group('authRedirect', () {
    test('keeps loading and error states on the interstitial', () {
      expect(authRedirect(const AsyncLoading(), '/interstitial'), isNull);
      expect(
        authRedirect(
          AsyncError<bool>(Exception('offline'), StackTrace.empty),
          '/',
        ),
        '/interstitial',
      );
    });

    test('sends an unauthenticated user to the auth landing page', () {
      expect(authRedirect(const AsyncData(false), '/interstitial'), '/auth');
      expect(authRedirect(const AsyncData(false), '/books'), '/auth');
      expect(authRedirect(const AsyncData(false), '/auth/sign-in'), isNull);
    });

    test('sends an authenticated user to the application', () {
      expect(authRedirect(const AsyncData(true), '/interstitial'), '/');
      expect(authRedirect(const AsyncData(true), '/books'), isNull);
    });
  });
}

ProviderContainer _createContainer(AuthRepository repository) {
  return ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
  );
}

final class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required this.hasSession, this.validationError});

  @override
  final bool hasSession;

  final Object? validationError;

  VoidCallback? _onUnauthenticated;
  int validationCount = 0;
  int signOutCount = 0;

  @override
  set onUnauthenticated(VoidCallback? callback) {
    _onUnauthenticated = callback;
  }

  void notifyUnauthenticated() {
    _onUnauthenticated?.call();
  }

  @override
  Future<void> validateSession() async {
    validationCount += 1;
    if (validationError case final error?) {
      throw error;
    }
  }

  @override
  Future<void> signIn(String username, String password) async {}

  @override
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {}

  @override
  Future<void> signOut() async {
    signOutCount += 1;
  }
}
