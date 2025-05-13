import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Services/driverdata.dart';
import 'package:qufi_driver_app/View/login/login_screen.dart' show LoginScreen;

import 'View/dashboard/dashboardscreen.dart';

// void main() {
//   runApp(MyApp());
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final driver = await SharedPrefsService.getDriverData();
  final bool isLoggedIn = driver != null;

  runApp(MaterialApp(home: isLoggedIn ? DashboardScreen() : LoginScreen()));
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
