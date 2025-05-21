// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/setting/password.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Core/Constants/utils/edit_password.dart';

import 'package:qufi_driver_app/Model/setting/password_model.dart';
import 'package:qufi_driver_app/View/Dashboard/dashboard_screen.dart';
import 'package:qufi_driver_app/Widgets/Login/custombutton.dart';
import 'package:qufi_driver_app/Widgets/Login/inputfield.dart';

class PasswordView extends StatefulWidget {
  const PasswordView({super.key});

  @override
  PasswordViewState createState() => PasswordViewState();
}

class PasswordViewState extends State<PasswordView> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  final PasswordController passwordController = PasswordController();
  bool isLoading = false;

  void updatePassword() async {
    String currentPassword = currentPasswordController.text.trim();
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmNewPasswordController.text.trim();

    // ✅ Use Validation Class
    String? currentError = PasswordValidator.validateCurrentPassword(
      currentPassword,
    );
    String? newError = PasswordValidator.validateNewPassword(newPassword);
    String? confirmError = PasswordValidator.validateConfirmPassword(
      newPassword,
      confirmPassword,
    );

    if (currentError != null || newError != null || confirmError != null) {
      showError(currentError ?? newError ?? confirmError!);
      return;
    }

    setState(() => isLoading = true);

    PasswordModel passwordModel = PasswordModel(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmPassword,
    );

    String responseMessage = await passwordController.updatePassword(
      passwordModel,
      "your-auth-token",
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(responseMessage)));

    if (responseMessage.contains("Password updated successfully")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DriverDashboardScreen()),
      );
    }

    setState(() => isLoading = false);
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text('Update Password'),
        ),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            InputField(
              isPassword: true,
              controller: currentPasswordController,
              label: 'Current Password',
            ),
            SizedBox(height: 20),
            InputField(
              isPassword: true,
              controller: newPasswordController,
              label: 'New Password',
            ),
            SizedBox(height: 20),
            InputField(
              isPassword: true,
              controller: confirmNewPasswordController,
              label: 'Confirm New Password',
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Save',
              onPressed: isLoading ? null : updatePassword,
            ),
          ],
        ),
      ),
    );
  }
}
