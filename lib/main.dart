import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/completed_orders_controller.dart';

import 'package:qufi_driver_app/Controller/location_controller.dart';
import 'package:qufi_driver_app/Controller/ongoing_orders_controller.dart';
import 'package:qufi_driver_app/Services/storage_service.dart';
import 'package:qufi_driver_app/View/dashboard/dashboardscreen.dart';
import 'package:qufi_driver_app/View/location_screen.dart';
import 'package:qufi_driver_app/View/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Check location permission
  bool locationEnabled = await LocationController().checkLocationPermission();
  if (!locationEnabled) {
    runApp(const LocationRequiredScreen());
    return;
  }

  // ✅ Load saved token
  final storageService = StorageService();
  final credentials = await storageService.getUserCredentials();
  final bool isLoggedIn = credentials['token'] != null;

  // ✅ Pass token using Provider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OngoingOrdersController()),
        ChangeNotifierProvider(create: (_) => CompletedOrdersController()),

        // Add more controllers here if needed
      ],
      child: MyApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qofi Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}
