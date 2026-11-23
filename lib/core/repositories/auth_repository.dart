import 'package:flutter/foundation.dart';

import '../http/client.dart';

/// Provides the authentication operations used by the application state.
abstract interface class AuthRepository {
  /// Whether locally stored credentials are available.
  bool get hasSession;

  /// Called when the HTTP client determines that the session is invalid.
  set onUnauthenticated(VoidCallback? callback);

  /// Validates the locally stored session against the backend.
  Future<void> validateSession();

  /// Creates an authenticated session for [username].
  Future<void> signIn(String username, String password);

  /// Registers a new user.
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
  });

  /// Clears the active session.
  Future<void> signOut();
}

/// Authentication repository backed by the application's API client.
final class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._client);

  final ApiClient _client;

  @override
  bool get hasSession => _client.isAuthenticated;

  @override
  set onUnauthenticated(VoidCallback? callback) {
    _client.onUnauthenticated = callback;
  }

  @override
  Future<void> validateSession() async {
    await _client.getCurrentUser();
  }

  @override
  Future<void> signIn(String username, String password) async {
    await _client.login(username: username, password: password);
  }

  @override
  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    await _client.register(
      username: username,
      email: email,
      password: password,
      extraFields: fullName == null || fullName.isEmpty
          ? null
          : {'first_name': fullName},
    );
  }

  @override
  Future<void> signOut() => _client.logout();
}
