import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/utils/login_utils.dart';
import 'package:qufi_driver_app/Services/loin_api.dart';
import 'package:qufi_driver_app/Services/savelogindata.dart';
import 'package:qufi_driver_app/View/dashboard/dashboardscreen.dart';

void logincontroller(
  BuildContext context,
  String username,
  String phone,
  String password,
) async {
  String? validationError = ValidationUtils.validateCredentials(
    username,
    phone,
    password,
  );

  if (validationError != null) {
    // ✅ Ensuring correct boolean check
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(validationError)));
    return;
  }

  final response = await AuthService().login(username, phone, password);

  if (response['success'] == true) {
    // ✅ Explicit boolean check
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
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login failed! Invalid credentials.")),
    );
  }
}
