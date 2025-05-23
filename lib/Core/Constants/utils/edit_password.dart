class PasswordValidator {
  static String? validateCurrentPassword(String? currentPassword) {
    // ✅ Accepts nullable String?
    if (currentPassword == null || currentPassword.isEmpty) {
      return "Current password is required!";
    }
    return null;
  }

  static String? validateNewPassword(String? newPassword) {
    // ✅ Accepts nullable String?
    if (newPassword == null || newPassword.length < 8) {
      return "New password must be at least 8 characters long!";
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? newPassword,
    String? confirmPassword,
  ) {
    // ✅ Accepts nullable String?
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Confirm password is required!";
    }
    if (newPassword != confirmPassword) {
      return "Confirm password does not match new password!";
    }
    return null;
  }
}
