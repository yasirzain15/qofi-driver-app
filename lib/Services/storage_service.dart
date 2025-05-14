import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveUserCredentials(
    String username,
    String password,
    String token,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    await prefs.setString('auth_token', token);
  }

  Future<Map<String, String?>> getUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString('username'),
      'password': prefs.getString('password'),
      'token': prefs.getString('auth_token'),
    };
  }

  Future<void> clearUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('password');
    await prefs.remove('auth_token');
  }
}
