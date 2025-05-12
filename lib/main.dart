import 'package:flutter/material.dart';
import 'package:qufi_driver_app/features/Dashboard/Presentation/dashboard_screen.dart';
import 'package:qufi_driver_app/features/orders/presentation/order_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
