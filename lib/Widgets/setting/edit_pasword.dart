// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/setting/password.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Core/Constants/utils/edit_password.dart';
import 'package:qufi_driver_app/Model/setting/password_model.dart';
import 'package:qufi_driver_app/View/Dashboard/dashboard_screen.dart';
import 'package:qufi_driver_app/View/setting/settingview.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // ✅ Form Key
  bool isLoading = false;

  void updatePassword() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => isLoading = false);
      return;
    }

    setState(() => isLoading = true);

    PasswordModel passwordModel = PasswordModel(
      currentPassword: currentPasswordController.text.trim(),
      newPassword: newPasswordController.text.trim(),
      confirmNewPassword: confirmNewPasswordController.text.trim(),
    );

    String responseMessage = await passwordController.updatePassword(
      passwordModel,
      "your-auth-token",
    );

    print("Raw Response: $responseMessage"); // ✅ Debugging output

    try {
      // ✅ Remove possible error prefix if present
      if (responseMessage.startsWith("Error: ")) {
        responseMessage = responseMessage.replaceFirst("Error: ", "");
      }

      // ✅ Check if response is JSON formatted
      if (responseMessage.startsWith("{")) {
        final responseData = jsonDecode(responseMessage);

        if (responseData["success"] == false &&
            responseData["message"] == "Current password is incorrect.") {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Current password is incorrect!"),
              backgroundColor: Colors.red,
            ),
          );
        } else if (responseData["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Password updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData["message"] ?? "Something went wrong"),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // ✅ Handle plain text responses (like "Password updated successfully!")
        if (responseMessage.contains("Password updated successfully")) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Password updated successfully!"),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DriverDashboardScreen()),
          );
        } else if (responseMessage.contains("Current password is incorrect")) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Current password is incorrect!"),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print("JSON Parsing Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(" An error occurred while processing the request"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),

              InputField(
                isPassword: true,
                validator: PasswordValidator.validateCurrentPassword,
                controller: currentPasswordController,
                label: 'Current Password',
              ),
              SizedBox(height: 20),
              InputField(
                isPassword: true,
                validator: PasswordValidator.validateNewPassword,
                controller: newPasswordController,
                label: 'New Password',
              ),
              SizedBox(height: 20),
              InputField(
                isPassword: true,
                controller: confirmNewPasswordController,
                label: 'Confirm New Password',
                validator:
                    (value) => PasswordValidator.validateConfirmPassword(
                      newPasswordController.text,
                      value ?? "",
                    ),
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Save',
                isLoading: isLoading,
                onPressed: isLoading ? null : updatePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
