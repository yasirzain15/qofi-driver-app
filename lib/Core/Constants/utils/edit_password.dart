class PasswordValidator {
  static String? validateCurrentPassword(String? currentPassword) {
    if (currentPassword == null || currentPassword.isEmpty) {
      return "Current password is required!";
    }

    return null;
  }

  static String? validateNewPassword(String? newPassword) {
    if (newPassword == null || newPassword.isEmpty) {
      return "New password is required!";
    }
    if (newPassword.length < 8) {
      return "New password must be at least 8 characters long!";
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? newPassword,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return "Confirm password is required!";
    }
    if (newPassword != confirmPassword) {
      return "Confirm password does not match new password!";
    }
    return null;
  }
}
