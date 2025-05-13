import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Services/loin_api.dart';
import 'package:qufi_driver_app/View/dashboard/dashboardscreen.dart';

import '../Core/Constants/utils/login_utils.dart';
import '../Services/savelogindata.dart';

class LoginController {
  void login(
    BuildContext context,
    String username,
    String phone,
    String password,
  ) async {
    // Validate user input
    String? validationError = ValidationUtils.validateCredentials(
      username,
      phone,
      password,
    );
    if (validationError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(validationError)));
      return;
    }

    // Call Login API
    final response = await AuthService().login(username, phone, password);

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed! Invalid credentials.")),
      );
    } else {
      await SharedPrefsService.saveDriverData(
        username,
        phone,
        password,
        response['data']['token'],
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    }
  }
}
