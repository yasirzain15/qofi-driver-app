import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Model/drivermodel.dart';
import 'package:qufi_driver_app/Services/api.dart';
import 'package:qufi_driver_app/Services/driverdata.dart';
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

      if (response['success'] == false) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed! Invalid credentials.")),
        );
        return false;
      }

      // 🛠 Debugging API Response
      if (kDebugMode) {
        print("API Response: $response");
      }

      // Extract driver data safely
      final driverJson = response['data']['driver'];
      final token = response['data']['token'];

      if (driverJson == null || token == null) {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text("Error retrieving login data.")));
        return false; // ✅ Ensure it returns false when data is missing
      }

      // Create Driver instance
      Driver driver = Driver(
        id: driverJson['id'],
        username: driverJson['username'],
        email: driverJson['email'],
        phone: driverJson['phone'],
        image: driverJson['image'],
        token: token,
      );

      // Store driver data globally
      await SharedPrefsService.saveDriverData(driver);

      final storedDriverData = await SharedPrefsService.getDriverData();
      if (kDebugMode) {
        print("Stored Driver Data: ${jsonEncode(storedDriverData)}");
      }
      // 🚀 Redirect to Dashboard
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );

      return true; // ✅ Always return true if login succeeds
    } catch (error) {
      if (kDebugMode) {
        print("Login Error: $error");
      }
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text("Unexpected error occurred.")));
      return false; // ✅ Return false in case of unexpected errors
    }
  }
}
