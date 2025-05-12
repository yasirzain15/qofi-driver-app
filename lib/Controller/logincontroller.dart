import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/utils/login_utils.dart';

class LoginController {
  void login(
    BuildContext context,
    String username,
    String phone,
    String password,
  ) {
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

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => ()),
    // );
  }
}
