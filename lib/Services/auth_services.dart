import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Core/Constants/api.dart';
import 'package:qufi_driver_app/Model/drivermodel.dart';
import 'package:qufi_driver_app/Services/storage_service.dart';

class AuthService {
  final _storageService = StorageService();

  Future<Map<String, dynamic>> login(String userInput, String password) async {
    try {
      // Determine if input is a phone number
      bool isPhoneNumber = RegExp(r'^\d+$').hasMatch(userInput);

      // Construct API request body dynamically
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
        if (kDebugMode) {
          if (kDebugMode) {
            print("Response Code: ${response.statusCode}");
          }
        }
      }
      if (kDebugMode) {
        print("Response Body: ${response.body}");
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
        final token = data['data']['token'];

        if (token == null || token.isEmpty) {
          return {'success': false, 'message': 'Token missing or invalid.'};
        }

        final driver = Driver.fromJson(driverData);

        // Save credentials dynamically
        await _storageService.saveUserCredentials(userInput, password, token);
        if (kDebugMode) {
          print("Stored Token: $token");
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
        print("Login Error: $e");
      }
      return {'success': false, 'message': 'Unexpected error occurred.'};
    }
  }

  Future<bool> sendDriverLocation(
    Map<String, dynamic> locationData,
    String token,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          "https://staging.riseupkw.net/qofi/api/v1/location/update",
        ), // ✅ Verify correct API endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ Include authentication token
        },
        body: jsonEncode(locationData), // ✅ Ensure JSON format
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("✅ Location updated successfully: ${response.body}");
        }
        return true;
      } else {
        if (kDebugMode) {
          print(" Failed to update location: ${response.body}");
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

  Future<String?> getToken() async {
    final creds = await _storageService.getUserCredentials();
    if (kDebugMode) {
      print("Retrieved Token: ${creds['token']}");
    }
    return creds['token'];
  }

  Future<void> logout() async {
    await _storageService.clearUserCredentials();
    if (kDebugMode) {
      print("User logged out successfully.");
    }
  }
}
