import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Model/setting/password_model.dart';

class PasswordController {
  final String apiUrl =
      'https://staging.riseupkw.net/qofi/api/v1/driver/update/password';

  Future<String> updatePassword(
    PasswordModel passwordModel,
    String token,
  ) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer 398|UvXNvRD0ygXG3SjXOVdb97wt3c9ARGHfmnPEYFT7171ea6f8',
    };

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(passwordModel.toJson()),
      );
      if (kDebugMode) {
        print('Status Code: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response Body: ${response.body}');
      }
      if (response.statusCode == 200) {
        return 'Password updated successfully!';
      } else {
        return 'Error: ${response.body}';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }
}
