import 'package:qufi_driver_app/Model/drivermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:qufi_driver_app/Core/Constants/api.dart';
import 'package:qufi_driver_app/Services/storage_service.dart';

class UserService {
  final _storageService = StorageService();

  Future<Driver?> fetchDriverData() async {
    final creds = await _storageService.getUserCredentials();
    if (creds['token'] == null) {
      return null; // No token, can't fetch API data
    }

    final response = await http.get(
      Uri.parse(ApiConstants.driverProfile), // Ensure correct endpoint
      headers: {'Authorization': 'Bearer ${creds['token']}'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Driver Data: $data"); // Debugging output
      return Driver.fromJson(data['data']['driver']); // Convert JSON into model
    } else {
      print("Failed to fetch driver data: ${response.statusCode}");
      return null;
    }
  }
}
