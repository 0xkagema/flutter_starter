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
}
