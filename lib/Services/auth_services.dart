import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Model/drivermodel.dart';
import 'dart:convert';
import 'package:qufi_driver_app/Core/Constants/api.dart';
import 'package:qufi_driver_app/Services/storage_service.dart';

class AuthService {
  final _storageService = StorageService();

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        if (data['success'] != true) {
          return {
            'success': false,
            'message': 'Login failed. Invalid credentials.',
          };
        }

        final driverData = data['data']['driver'];
        final token = data['data']['token'];

        if (token == null || token.isEmpty) {
          return {'success': false, 'message': 'Token missing or invalid.'};
        }

        final driver = Driver.fromJson(driverData);

        await _storageService.saveUserCredentials(username, password, token);
        print("Stored Token: $token");

        return {'success': true, 'token': token, 'driver': driver};
      } else {
        return {
          'success': false,
          'message': 'Login failed. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      print("Login Error: $e");
      return {'success': false, 'message': 'Unexpected error occurred.'};
    }
  }

  Future<String?> getToken() async {
    final creds = await _storageService.getUserCredentials();
    print("Retrieved Token: ${creds['token']}");
    return creds['token'];
  }

  Future<void> logout() async {
    await _storageService.clearUserCredentials();
    print("User logged out successfully.");
  }
}
