import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final TextInputType keyboardType;

  const InputField({
    super.key,
    required this.controller,
    required this.label,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        enabled: true,
        labelText: label,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 1.0), // Thin border
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: 2.0,
          ), // Highlighted border when focused
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label cannot be empty';
        }
        return null;
      },
    );
  }
}
