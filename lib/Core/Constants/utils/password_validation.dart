class PasswordValidator {
  static bool isValidPassword(String password) {
    return password.length >= 8;
    // password.contains(RegExp(r'[A-Z]')) &&
    // password.contains(RegExp(r'[a-z]')) &&
    // password.contains(RegExp(r'[0-9]')) &&
    // password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
  }

  static bool doPasswordsMatch(
    // String currentpassword,
    newPassword,
    String confirmPassword,
  ) {
    return newPassword == confirmPassword;
  }
}
