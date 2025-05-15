import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qufi_driver_app/Controller/location_controller.dart';
import 'package:qufi_driver_app/Controller/logincontroller.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Services/storage_service.dart';

import 'package:qufi_driver_app/View/dashboard/dashboardscreen.dart';
import 'package:qufi_driver_app/Widgets/Login/custombutton.dart';
import 'package:qufi_driver_app/Widgets/Login/inputfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController _controller = LoginController();

  bool _isLoading = false;

  void _login() async {
    String userInput = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    bool isPhoneNumber = RegExp(r'^\d+$').hasMatch(userInput);

    Map<String, dynamic> requestData = {
      if (!isPhoneNumber) "username": userInput,
      if (isPhoneNumber) "phone": userInput,
      "password": password,
    };

    if (kDebugMode) {
      print("Final Login Request: ${jsonEncode(requestData)}");
    } // Debugging Output

    setState(() => _isLoading = true);

    bool success = await _controller.login(
      context,
      requestData["username"] ?? requestData["phone"] ?? "",
      requestData["password"]!,
    );

    setState(() => _isLoading = false);

    if (success) {
      Position? location = await LocationController().getCurrentLocation();
      if (location != null) {
        if (kDebugMode) {
          print("User Location: ${location.latitude}, ${location.longitude}");
        }
      }

      await StorageService().saveUserCredentials(
        userInput,
        password,
        "dummyToken",
      );
      if (!mounted) {
        return; // Ensures the widget is still active before navigating
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      if (!mounted) return; // Prevents accessing context if widget is disposed

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed! Please check credentials.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
            child: Text('Login', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 70),
              InputField(
                controller: _usernameController,
                label: 'Enter Username or PhoneNumber',
              ),
              SizedBox(height: 20),
              InputField(
                controller: _passwordController,
                label: 'Enter Password',
                isPassword: true,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : CustomButton(text: 'Login', onPressed: _login),
            ],
          ),
        ),
      ),
    );
  }
}
