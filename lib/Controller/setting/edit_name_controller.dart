import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:qufi_driver_app/Core/Constants/api.dart';

class NameService {
  /// Update name in API and store locally
  Future<Map<String, dynamic>> updateUserName(
    String newName,
    String token,
  ) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 577|hCQkCcXVHaA7108CTceQgDLIRftiTfjl5rQMSMFp886f56b0',
      };

      Map<String, dynamic> requestData = {'name': newName};

      final response = await http.put(
        Uri.parse(ApiConstants.updatedrivername),
        headers: headers,
        body: jsonEncode(requestData),
      );

      if (kDebugMode) {
        print("🔹 API Response Code: ${response.statusCode}");
        print("🔹 API Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        await _saveUserNameLocally(newName); // ✅ Save locally after API success
        return {'success': true, 'message': 'Name updated successfully!'};
      } else {
        return {
          'success': false,
          'message': 'Failed to update name: ${response.body}',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print(" Name Update Error: $e");
      }
      return {'success': false, 'message': 'Unexpected error occurred.'};
    }
  }

  /// Save name locally
  Future<void> _saveUserNameLocally(String newName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', newName);
  }

  /// Retrieve name from local storage
  Future<String?> getLocalUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }
}
