import 'package:dio/dio.dart';

import '../http/client.dart';

class AuthService {
  static Future<Map<String, dynamic>> signIn(
    String username,
    String password,
  ) async {
    return await ApiClient.instance.login(
      username: username,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await ApiClient.instance.logout();
  }

  static bool get isAuthenticated => ApiClient.instance.isAuthenticated;

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    return await ApiClient.instance.register(
      username: username,
      email: email,
      password: password,
      extraFields: fullName == null || fullName.isEmpty
          ? null
          : {'first_name': fullName},
    );
  }

  static Future<Response<dynamic>> requestPasswordReset(String email) {
    return ApiClient.instance.requestPasswordReset(email: email);
  }

  static Future<Response<dynamic>> confirmPasswordReset({
    required String uid,
    required String token,
    required String newPassword,
  }) {
    return ApiClient.instance.confirmPasswordReset(
      uid: uid,
      token: token,
      newPassword: newPassword,
    );
  }
}
