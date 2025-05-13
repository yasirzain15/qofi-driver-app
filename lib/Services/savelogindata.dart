import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static Future<void> saveDriverData(
    String username,
    String password,
    String token,
    response,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('driver_username', 'testdriver');
    await prefs.setString('driver_password', '12345678');
    await prefs.setString(
      'auth_token',
      '210|xaRNSstRJRyFgaeLTDSiPIECo7PwXOvO5rfmQQIPa1f4ef29',
    );
  }

  static Future<Map<String, String?>> getDriverData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString('driver_username'),
      'password': prefs.getString('driver_password'),
      'token': prefs.getString('auth_token'),
    };
  }

  static Future<void> removeDriverData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('driver_username');
    await prefs.remove('driver_password');
    await prefs.remove('auth_token');
  }
}
