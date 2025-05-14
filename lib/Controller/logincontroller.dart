import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:qufi_driver_app/Services/auth_services.dart';

import 'package:qufi_driver_app/View/dashboard/dashboardscreen.dart';

class LoginController {
  final _authService = AuthService();

  Future<bool> login(
    BuildContext context,
    String username,
    String password,
    String text,
  ) async {
    try {
      final response = await _authService.login(username, password);

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

      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
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
