import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Services/savelogindata.dart';
import 'package:qufi_driver_app/View/login/login_screen.dart';

class AuthController {
  //login
  Future<bool> isDriverLoggedIn() async {
    final driverData = await SharedPrefsService.getDriverData();
    return driverData['token'] != null;
  }

  // logoutfunction
  Future<void> logout(BuildContext context) async {
    await SharedPrefsService.removeDriverData();
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
