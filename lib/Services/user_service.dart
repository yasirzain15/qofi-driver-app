import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  Future<String?> fetchCurrentPassword() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedPassword = prefs.getString("stored_password");

      if (storedPassword == null || storedPassword.isEmpty) {
        if (kDebugMode) {
          print(" No stored password found. Make sure it was saved first.");
        }
        return null;
      }

      if (kDebugMode) {
        print("✅ Retrieved stored password successfully: $storedPassword");
      }
      return storedPassword;
    } catch (e) {
      if (kDebugMode) {
        print(" Exception while fetching password: $e");
      }
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
        if (kDebugMode) {
          print("Error: No authentication token found");
        }
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

      if (kDebugMode) {
        print("Response Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("Response Body: ${response.body}");
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print("Error updating password: $e");
      }
      return false;
    }
  }

  Future<void> saveNewPasswordLocally(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('stored_password', newPassword);
  }
}
