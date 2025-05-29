// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qufi_driver_app/Core/Constants/api.dart';

import 'package:qufi_driver_app/View/login/login_screen.dart';
import 'package:flutter/material.dart';

import '../Model/setting/drivermodel.dart';

class AuthService {
  /// Login Function: Stores Token & User Info
  Future<Map<String, dynamic>> login(String userInput, String password) async {
    try {
      bool isPhoneNumber = RegExp(r'^\d+$').hasMatch(userInput);

      Map<String, String> requestData = {
        if (!isPhoneNumber) "username": userInput,
        if (isPhoneNumber) "phone": userInput,
        "password": password,
      };

      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (kDebugMode) {
        print("🔹 Response Code: ${response.statusCode}");
        print("🔹 Response Body: ${response.body}");
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        if (data['success'] != true) {
          return {
            'success': false,
            'message': 'Login failed. Invalid credentials.',
          };
        }

        final driverData = data['data']['driver'];
        final String? token = data['data']['token']; // ✅ Retrieve token

        if (token == null || token.isEmpty) {
          return {'success': false, 'message': 'Token missing or invalid.'};
        }

        final driver = Driver.fromJson(driverData);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);
        await prefs.setString(
          "name",
          driverData["name"] ?? "Driver",
        ); // ✅ Store user name
        await prefs.setString("username", driverData["username"]);
        await prefs.setString("image", driverData["image"]);

        if (kDebugMode) {
          print("✅ Stored Auth Token: $token");
          print("✅ Stored Name: ${prefs.getString("name")}");
          print("✅ Stored Username: ${prefs.getString("username")}");
        }

        return {'success': true, 'token': token, 'driver': driver};
      } else {
        return {
          'success': false,
          'message': 'Login failed. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Login Error: $e");
      }
      return {'success': false, 'message': 'Unexpected error occurred.'};
    }
  }

  /// Retrieve stored authentication token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (kDebugMode) {
      print("🔑 Retrieved Token from Storage: $token");
    }

    return token;
  }

  /// Retrieve stored user name
  Future<String?> getStoredUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("name"); // ✅ Retrieve stored name
  }

  /// Sends Driver Location to API
  Future<bool> sendDriverLocation(
    Map<String, dynamic> locationData,
    String token,
  ) async {
    if (token.isEmpty) {
      if (kDebugMode) {
        print("❌ Token missing! Cannot send location.");
      }
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.updatelocation),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(locationData),
      );

      if (kDebugMode) {
        print("📡 Location Update Status: ${response.statusCode}");
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error sending location: $e");
      }
      return false;
    }
  }

  /// Logout Function: Clears Stored Data
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // ✅ Remove stored user data

    if (kDebugMode) {
      print("🚪 User logged out successfully.");
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false, // ✅ Clears navigation history
    );
  }

  /// Retrieve stored Driver ID
  Future<String?> getDriverId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('driver_id'); // ✅ Retrieve stored driver ID
  }
}
