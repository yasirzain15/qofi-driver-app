// import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveUserCredentials(
    String userIdentifier,
    String password,
    String token,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userIdentifier', userIdentifier);
    await prefs.setString('password', password);
    await prefs.setString('auth_token', token);
    print("✅ Credentials stored successfully.");
  }

  Future<Map<String, String?>> getUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'userIdentifier': prefs.getString('userIdentifier'),
      'password': prefs.getString('password'),
      'token': prefs.getString('auth_token'),
    };
  }

  Future<void> clearUserCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userIdentifier');
    await prefs.remove('password');
    await prefs.remove('auth_token');
    print("🧹 Credentials cleared successfully.");
  }
}
