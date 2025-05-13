import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/authcontroller/auth_controller.dart';
import 'package:qufi_driver_app/View/login/login_screen.dart';

import 'View/dashboard/dashboardscreen.dart';

// void main() {
//   runApp(MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthController authController = AuthController();
  bool isDriverLoggedIn = await authController.isDriverLoggedIn();

  runApp(
    MaterialApp(home: isDriverLoggedIn ? DashboardScreen() : LoginScreen()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qofi Driver',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DashboardScreen(),
    );
  }
}
