import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/logincontroller.dart';
import 'package:qufi_driver_app/Widgets/Login/custombutton.dart';
import 'package:qufi_driver_app/Widgets/Login/inputfield.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginController _controller = LoginController();

  void _login() {
    _controller.login(
      context,
      _usernameController.text,
      _phoneController.text,
      _passwordController.text,
    );
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
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              InputField(
                controller: _passwordController,
                label: 'Password',
                isPassword: true,
              ),
              SizedBox(height: 20),
              CustomButton(text: 'Login', onPressed: _login),
            ],
          ),
        ),
      ),
    );
  }
}
