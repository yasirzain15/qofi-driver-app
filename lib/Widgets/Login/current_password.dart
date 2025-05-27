// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Widgets/Login/inputfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentPasswordField extends StatefulWidget {
  final TextEditingController controller;

  const CurrentPasswordField({super.key, required this.controller});

  @override
  _CurrentPasswordFieldState createState() => _CurrentPasswordFieldState();
}

class _CurrentPasswordFieldState extends State<CurrentPasswordField> {
  String? currentPasswordError;
  String? storedPassword; // ✅ Store password separately

  @override
  void initState() {
    super.initState();
    _fetchStoredPassword(); // ✅ Fetch password on widget load
  }

  Future<void> _fetchStoredPassword() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      storedPassword =
          prefs.getString('correctPassword') ?? ""; // ✅ Update stored password
    });
  }

  @override
  Widget build(BuildContext context) {
    return InputField(
      isPassword: true,
      controller: widget.controller,
      label: 'Current Password',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Current password is required!";
        }
        if (storedPassword != null && value != storedPassword) {
          return "Current password is incorrect!";
        }
        return null;
      },
    );
  }
}
