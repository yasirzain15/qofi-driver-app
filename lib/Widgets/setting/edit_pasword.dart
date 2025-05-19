import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/setting/user_controller.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Core/Constants/utils/password_validation.dart';
import 'package:qufi_driver_app/View/Dashboard/dashboard_screen.dart';
import 'package:qufi_driver_app/Widgets/Login/custombutton.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  EditPasswordScreenState createState() => EditPasswordScreenState();
}

class EditPasswordScreenState extends State<EditPasswordScreen> {
  final UserController _userController = UserController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? errorMessage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrentPassword();
  }

  /// **Fetch current password from Controller**
  Future<void> _fetchCurrentPassword() async {
    final user = await _userController.getUserPassword();
    if (user != null) {
      setState(() {
        currentPasswordController.text = user.currentPassword;
      });
    }
  }

  /// **Handle password update**
  void _updatePassword() async {
    setState(() {
      errorMessage = null;
      isLoading = true; // Start loading
    });

    // ✅ Ensure Current Password is Entered
    if (currentPasswordController.text.isEmpty) {
      setState(() {
        errorMessage = "Current password cannot be empty.";
        isLoading = false;
      });
      return;
    }

    // ✅ Validate New Password Strength
    if (!PasswordValidator.isValidPassword(newPasswordController.text)) {
      setState(() {
        errorMessage = "password must be 8 ";
        // "Password must be at least 6 characters, include uppercase, lowercase, number, and special character.";
        isLoading = false;
      });
      return;
    }

    // ✅ Validate Confirm Password Match
    if (!PasswordValidator.doPasswordsMatch(
      newPasswordController.text,

      confirmPasswordController.text,
    )) {
      setState(() {
        errorMessage = "New password and confirm password do not match.";
        isLoading = false;
      });
      return;
    }

    // ✅ Verify Current Password Correctness
    bool isCurrentPasswordValid = await _userController.validateCurrentPassword(
      currentPasswordController.text,
    );
    if (!isCurrentPasswordValid) {
      setState(() {
        errorMessage = "Incorrect current password.";
        isLoading = false;
      });
      return;
    }

    // 🚀 Attempt Password Update
    bool success = await _userController.updateUserPassword(
      currentPasswordController.text,
      newPasswordController.text,
      confirmPasswordController.text,
    );

    setState(() {
      isLoading = false;
      errorMessage = success ? null : "Password update failed.";
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully!")),
      );

      /// 🚀 Navigate to the next screen after successful update
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DriverDashboardScreen(),
        ), // Replace with your actual screen
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("Edit Password"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (errorMessage != null) _buildErrorText(errorMessage!),
                _buildPasswordField(
                  currentPasswordController,
                  "Current Password",
                ),
                _buildPasswordField(newPasswordController, "New Password"),
                _buildPasswordField(
                  confirmPasswordController,
                  "Confirm Password",
                ),
                const SizedBox(height: 20),
                Center(
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _buildSaveButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// **Reusable Error Message Widget**
  Widget _buildErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(error, style: const TextStyle(color: Colors.red)),
    );
  }

  /// **Reusable Password Input Field**
  Widget _buildPasswordField(TextEditingController controller, String label) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: TextFormField(
        controller: controller,

        obscureText: true,
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: InputBorder.none,
          labelText: label,
          filled: true,
          // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label cannot be empty';
          }
          return null;
        },
      ),
    );
  }

  /// **Save Button**
  Widget _buildSaveButton() {
    return SizedBox(
      child: CustomButton(text: 'Save', onPressed: _updatePassword),
    );
  }
}
