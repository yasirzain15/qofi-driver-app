import 'package:flutter/material.dart';
import 'package:qufi_driver_app/View/dashboard/dashboardscreen.dart';

import 'package:qufi_driver_app/Widgets/Login/custombutton.dart';
import 'package:qufi_driver_app/Widgets/Login/inputfield.dart';

import '../../Controller/logincontroller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController _controller =
      LoginController(); // ✅ Connects LoginController

  void _login() async {
    bool success = await _controller.login(
      context,
      _usernameController.text,
      _passwordController.text,
      _phoneController.text,
    );

    if (success) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed! Please check credentials.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputField(controller: _usernameController, label: 'Username'),
              SizedBox(height: 10),
              InputField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Login',
                onPressed: _login,
              ), // ✅ Calls `_login()`
            ],
          ),
        ),
      ),
    );
  }
}
