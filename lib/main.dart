import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/location_controller.dart';
import 'package:qufi_driver_app/Services/storage_service.dart';
import 'package:qufi_driver_app/View/dashboard/dashboardscreen.dart';
import 'package:qufi_driver_app/View/location_screen.dart';
import 'package:qufi_driver_app/View/login/login_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensures async execution before runApp

//   final storageService = StorageService(); // Create instance
//   final credentials =
//       await storageService.getUserCredentials(); // Fetch saved credentials
//   final bool isLoggedIn = credentials['token'] != null; // Check if token exists

//   runApp(MyApp(isLoggedIn: isLoggedIn)); // Pass login state to MyApp
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures async execution before runApp

  // ✅ Check location permission before anything else
  bool locationEnabled = await LocationController().checkLocationPermission();

  if (!locationEnabled) {
    runApp(LocationRequiredScreen()); // ✅ Show location prompt first
    return;
  }

  final storageService = StorageService(); // Create instance
  final credentials =
      await storageService.getUserCredentials(); // Fetch saved credentials
  final bool isLoggedIn = credentials['token'] != null; // Check if token exists

  runApp(MyApp(isLoggedIn: isLoggedIn)); // Pass login state to MyApp
}

class MyApp extends StatelessWidget {
  final bool? isLoggedIn; // Stores login state

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qofi Driver',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:
          (isLoggedIn ?? false)
              ? DashboardScreen()
              : LoginScreen(), // Show appropriate screen
    );
  }
}
