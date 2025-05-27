// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Core/Constants/api.dart';
import 'package:qufi_driver_app/Model/setting/drivermodel.dart';
import 'package:qufi_driver_app/Services/storage_service.dart';
import 'package:qufi_driver_app/View/login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _storageService = StorageService();

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
        final String? token = data['data']['token']; //  Retrieve token

        if (token == null || token.isEmpty) {
          return {'success': false, 'message': 'Token missing or invalid.'};
        }

        final driver = Driver.fromJson(driverData);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("auth_token", token);
        await prefs.setString("name", driverData["name"] ?? "Driver");
        await prefs.setString("username", driverData["username"]);
        await prefs.setString("image", driverData["image"]);
        String? storedImageUrl = prefs.getString("image");
        if (kDebugMode) {
          print(" Stored Image URL: $storedImageUrl");
        }

        if (kDebugMode) {
          print(" Stored Auth Token: $token");
        }
        if (kDebugMode) {
          print(" Stored Username: ${prefs.getString("username")}");
        }
        if (kDebugMode) {
          print(" Stored Image URL: ${prefs.getString("image")}");
        }

        await _storageService.saveUserCredentials(userInput, password, token);

        return {'success': true, 'token': token, 'driver': driver};
      } else {
        return {
          'success': false,
          'message': 'Login failed. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print(" Login Error: $e");
      }
      return {'success': false, 'message': 'Unexpected error occurred.'};
    }
  }

  ///  Retrieves Stored Token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (kDebugMode) {
      print(" Retrieved Token from Storage: $token");
    } // Debugging

    return token;
  }

  ///  Sends Driver Location to API
  Future<bool> sendDriverLocation(
    Map<String, dynamic> locationData,
    String token,
  ) async {
    String? token = await getToken(); //  Retrieve stored token

    if (token == null || token.isEmpty) {
      if (kDebugMode) {
        print(" Token missing! Cannot send location.");
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
        print("🌐 API Request Sent!  Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("📜 Full Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(" Location updated successfully!");
        }
        return true;
      } else {
        if (kDebugMode) {
          print(" Backend rejected update: ${response.body}");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(" Error sending location: $e");
      }
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); //  Remove all stored user data

    if (kDebugMode) {
      print(" User logged out successfully.");
    }

    // Redirect to login screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false, //  Clears navigation history
    );
  }

  Future<String?> getDriverId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('driver_id'); //  Retrieve stored driver ID
  }
}
