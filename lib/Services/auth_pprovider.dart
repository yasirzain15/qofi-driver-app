import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoggedIn = false; // Default state

  Future<void> checkLoginStatus() async {
    final storageService = StorageService();
    final credentials = await storageService.getUserCredentials();

    isLoggedIn = credentials['token'] != null; // Check token validity
  }
}
