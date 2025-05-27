import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePassword(String newPassword) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('correctPassword', newPassword);
}

Future<String?> getStoredPassword() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('correctPassword'); // Returns stored password
}
