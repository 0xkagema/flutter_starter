import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../http/client.dart';
import '../repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return ApiAuthRepository(ApiClient.instance);
});

final authProvider = AsyncNotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
  retry: (_, _) => null,
);

final routerRefreshProvider = Provider<RouterRefreshNotifier>((ref) {
  final notifier = RouterRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final repository = ref.watch(authRepositoryProvider);

    void handleUnauthenticated() {
      state = const AsyncData(false);
    }

    repository.onUnauthenticated = handleUnauthenticated;
    ref.onDispose(() {
      repository.onUnauthenticated = null;
    });

    if (!repository.hasSession) {
      return false;
    }

    try {
      await repository.validateSession();
      return true;
    } on UnauthorizedException {
      await repository.signOut();
      return false;
    }
  }

  Future<bool> signIn(String username, String password) async {
    await ref.read(authRepositoryProvider).signIn(username, password);

    state = const AsyncData(true);
    return true;
  }

  Future<bool> signUp({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    await ref
        .read(authRepositoryProvider)
        .signUp(
          username: username,
          email: email,
          password: password,
          fullName: fullName,
        );
    return true;
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();

    state = const AsyncData(false);
  }

  void retrySessionValidation() {
    ref.invalidateSelf();
  }
}

class RouterRefreshNotifier extends ChangeNotifier {
  final Ref ref;

  RouterRefreshNotifier(this.ref) {
    ref.listen<AsyncValue<bool>>(authProvider, (_, _) {
      notifyListeners();
    });
  }
}
