// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:qufi_driver_app/Services/auth_services.dart';
import 'package:qufi_driver_app/Controller/location_controller.dart';
import 'package:geolocator/geolocator.dart';

import 'package:qufi_driver_app/View/bottom_nav_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  final _authService = AuthService();
  final _locationController = LocationController();

  /// **Login Function (Handles Token & User Details)**
  Future<bool> login(
    BuildContext context,
    String userInput,
    String password,
  ) async {
    try {
      final response = await _authService.login(userInput, password);

      if (!response['success']) {
        _showSnackBar(context, "Login failed! Invalid credentials.");
        return false;
      }

      //  Extract Token & Store in SharedPreferences
      final String? token = response['token'];
      if (token == null || token.isEmpty) {
        _showSnackBar(context, "Token missing from response.");
        return false;
      }

      await _storeToken(token); //  Store token locally

      if (kDebugMode) {
        print("Login successful. Token: $token");
      }

      //  Fetch driver's location after login
      Position? location = await _locationController.getCurrentLocation();
      if (location != null) {
        if (kDebugMode) {
          print(
            "Driver's Location: ${location.latitude}, ${location.longitude}",
          );
        }

        //  Send location to backend
        Map<String, dynamic> locationData = {
          "latitude": location.latitude,
          "longitude": location.longitude,
        };
        await _authService.sendDriverLocation(locationData, token);
      }

      // ✅ Navigate to Dashboard
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavScreen()),
        );
      });

      return true;
    } catch (e) {
      if (kDebugMode) print("Login error: $e");
      _showSnackBar(context, "Unexpected error occurred.");
      return false;
    }
  }

  ///  **Store Token in SharedPreferences**
  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("auth_token", token); //  Saves token
    if (kDebugMode) {
      print(" Token stored successfully.");
    }
  }

  ///  **Retrieve Token from SharedPreferences**
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      "auth_token",
    ); //  Fetch token before making API calls
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
