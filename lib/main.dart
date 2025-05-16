import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/completed_orders_controller.dart';
import 'package:qufi_driver_app/Controller/location_controller.dart';
import 'package:qufi_driver_app/Controller/ongoing_orders_controller.dart';
import 'package:qufi_driver_app/Services/storage_service.dart';
import 'package:qufi_driver_app/View/bottom_nav_screen.dart';
import 'package:qufi_driver_app/View/location_screen.dart';
import 'package:qufi_driver_app/View/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("🔧 Initializing App...");

  // ✅ Check location permission
  bool locationEnabled = await LocationController().checkLocationPermission();
  print("📍 Location permission: $locationEnabled");

  if (!locationEnabled) {
    runApp(const LocationRequiredScreen());
    return;
  }

  // ✅ Load saved token
  final storageService = StorageService();
  final credentials = await storageService.getUserCredentials();
  final String? token = credentials['token'];
  print("🔑 Token: $token");

  final bool isLoggedIn = token != null;

  runApp(MyApp(isLoggedIn: isLoggedIn, token: token ?? ''));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String token;

  const MyApp({super.key, required this.isLoggedIn, required this.token});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final ongoingController = OngoingOrdersController();
            Future.microtask(() => ongoingController.fetchOngoingOrders(token));
            return ongoingController;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final completedController = CompletedOrdersController();
            Future.microtask(
              () => completedController.fetchCompletedOrders(token),
            );
            return completedController;
          },
        ),
      ],
      child: MaterialApp(
        title: 'Qofi Driver',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: isLoggedIn ? const BottomNavScreen() : const LoginScreen(),
      ),
    );
  }
}
