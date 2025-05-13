import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<Map<String, dynamic>> login(
    String username,
    String phone,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('YOUR_LOGIN_API_URL'),
      body: {'username': username, 'phone': phone, 'password': password},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'success': false};
    }
  }
}
