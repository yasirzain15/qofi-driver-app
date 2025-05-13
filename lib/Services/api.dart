import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://staging.riseupkw.net/qofi/api/v1/driver/login'),
      body: {'username': 'testdriver', 'password': '12345678'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // ✅ Returns API response data
    } else {
      return {'success': false}; // ✅ Ensures a valid return type
    }
  }
}
