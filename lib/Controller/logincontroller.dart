// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:qufi_driver_app/Services/auth_services.dart';
import 'package:qufi_driver_app/Controller/location_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qufi_driver_app/View/bottom_nav_screen.dart';

class LoginController {
  final _authService = AuthService();
  final _locationController = LocationController();

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

      final token = response['token'];
      if (token == null || token.isEmpty) {
        _showSnackBar(context, "Token missing from response.");
        return false;
      }

      if (kDebugMode) {
        print("Login successful. Token: $token");
      }

      // ✅ Fetch driver's location after login
      Position? location = await _locationController.getCurrentLocation();
      if (location != null) {
        if (kDebugMode) {
          print(
            "Driver's Location: ${location.latitude}, ${location.longitude}",
          );
        }

        // ✅ Optional: Send location to backend
        Map<String, dynamic> locationData = {
          "latitude": location.latitude,
          "longitude": location.longitude,
        };
        // ✅ Get the stored token
        await _authService.sendDriverLocation(locationData, token);
      }

      _showSnackBar(context, "Login successful!");

      // ✅ Smooth transition to Dashboard
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
