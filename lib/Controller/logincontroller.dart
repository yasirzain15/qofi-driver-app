import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:qufi_driver_app/Services/auth_services.dart';
import 'package:qufi_driver_app/View/dashboard/dashboardscreen.dart';

class LoginController {
  Future<bool> login(
    BuildContext context,
    String username,
    String phone,
    String password,
  ) async {
    try {
      final response = await AuthService().login(username, password);

      if (!response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed! Invalid credentials.")),
        );
        return false;
      }

      final token = response['token'];
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Token missing from response.")),
        );
        return false;
      }

      if (kDebugMode) {
        print("Login successful. Token: $token");
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );

      return true;
    } catch (e) {
      if (kDebugMode) print("Login error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unexpected error occurred.")),
      );
      return false;
    }
  }
}
