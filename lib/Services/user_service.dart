import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  /// Fetch current password from API
  ///
  // Future<String?> fetchCurrentPassword() async {
  //   final response = await http.get(
  //     Uri.parse('https://staging.riseupkw.net/qofi/api/v1/driver/login'),
  //   );
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body)['password'];
  //   } else {
  //     return null;
  //   }
  // }
  Future<String?> fetchCurrentPassword() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedPassword = prefs.getString("stored_password");

      if (storedPassword == null || storedPassword.isEmpty) {
        print("❌ No stored password found. Make sure it was saved first.");
        return null;
      }

      print("✅ Retrieved stored password successfully: $storedPassword");
      return storedPassword;
    } catch (e) {
      print("❌ Exception while fetching password: $e");
      return null;
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token"); // ✅ Fetch stored token
  }

  /// Update password in API
  Future<bool> updatePassword(String newPassword) async {
    try {
      final authToken = await getToken(); // 🔹 Fetch stored token

      if (authToken == null) {
        print("Error: No authentication token found");
        return false;
      }

      final response = await http.put(
        Uri.parse(
          'https://staging.riseupkw.net/qofi/api/v1/driver/update/password',
        ),
        headers: {
          'Authorization': 'Bearer $authToken', // ✅ Include token here
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'password': newPassword}),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error updating password: $e");
      return false;
    }
  }

  Future<void> saveNewPasswordLocally(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('stored_password', newPassword);
  }
}
