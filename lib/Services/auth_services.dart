import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Model/drivermodel.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qufi_driver_app/Core/Constants/api.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final driver = Driver.fromJson(data['data']);

        //  Save only the token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', driver.token);

        return {'success': true, 'token': driver.token};
      } else {
        return {
          'success': false,
          'message': 'Login failed. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}
