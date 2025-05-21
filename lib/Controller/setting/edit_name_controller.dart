import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Model/setting/edit_name_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NameController {
  final String apiUrl =
      'https://staging.riseupkw.net/qofi/api/v1/driver/update/name';

  Future<String> updateName(NameModel nameModel, String token) async {
    // ✅ Get stored token dynamically

    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer 398|UvXNvRD0ygXG3SjXOVdb97wt3c9ARGHfmnPEYFT7171ea6f8 ',
    };
    //  398|UvXNvRD0ygXG3SjXOVdb97wt3c9ARGHfmnPEYFT7171ea6f8
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(nameModel.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print("✅ API Response: $responseData");
        } // Debugging step

        await _saveDriverName(nameModel.name);
        return 'Name updated successfully!';
      } else {
        if (kDebugMode) {
          print("❌ API Error: ${response.body}");
        } // Debugging step
        return 'Error: ${response.body}';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }

  Future<void> _saveDriverName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('driverName', name);
  }

  Future<String?> getDriverName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('driverName');
    print("✅ Saved Name: $name");
    if (kDebugMode) {
      print("🔍 Retrieved Name from Storage: $name");
    } // Debugging step

    return name;
  }
}
