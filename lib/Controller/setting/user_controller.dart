import 'package:qufi_driver_app/Core/Constants/utils/password_validation.dart';
import 'package:qufi_driver_app/Model/setting/settingmodel.dart';
import 'package:qufi_driver_app/Services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  final UserService _userService = UserService();

  /// 🔹 Fetch current password from API
  Future<SettingsModel?> getUserPassword() async {
    try {
      final password = await _userService.fetchCurrentPassword();

      if (password != null && password.isNotEmpty) {
        return SettingsModel(currentPassword: password);
      } else {
        print(
          "Error: No stored password found. Please ensure password is saved in storage.",
        );
        return null;
      }
    } catch (e) {
      print("Exception in getUserPassword: $e");
      return null;
    }
  }

  /// 🔹 Validate if current password is correct
  Future<bool> validateCurrentPassword(String currentPassword) async {
    final storedPassword = await _userService.fetchCurrentPassword();

    if (storedPassword == null || storedPassword.isEmpty) {
      print("Error: No stored password found.");
      return false;
    }

    if (storedPassword != currentPassword) {
      print("Error: Current password is incorrect.");
      return false;
    }

    return true; // ✅ Password is correct
  }

  /// 🔹 Update Password With Proper Validation
  Future<bool> updateUserPassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    // ✅ Check if current password is valid
    bool isCurrentPasswordValid = await validateCurrentPassword(
      currentPassword,
    );
    if (!isCurrentPasswordValid) {
      print("Error: Incorrect current password.");
      return false;
    }

    // ✅ Validate new password format
    if (!PasswordValidator.isValidPassword(newPassword)) {
      print("Error: Password does not meet security requirements.");
      return false;
    }

    // ✅ Confirm password match
    if (!PasswordValidator.doPasswordsMatch(newPassword, confirmPassword)) {
      print("Error: New password and confirm password do not match.");
      return false;
    }

    // 🔹 Proceed with password update
    bool isUpdated = await _userService.updatePassword(newPassword);
    if (isUpdated) {
      await _savePasswordLocally(newPassword);
      return true;
    } else {
      print("Failed to update password.");
      return false;
    }
  }

  /// 🔹 Store updated password locally (optional)
  Future<void> _savePasswordLocally(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('stored_password', newPassword);
    print("Password stored successfully in local storage.");
  }
}
