class ValidationUtils {
  static String? validateCredentials(
    String username,
    String phone,
    String password,
  ) {
    if (username.isEmpty || phone.isEmpty || password.isEmpty) {
      return 'All fields are required';
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      return 'Enter a valid 10-digit phone number';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null; // Validation passed
  }
}
