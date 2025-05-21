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
    return Card(
      elevation: 1,
      color: Colors.white,
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: InputBorder.none,
          labelText: label,
          filled: true,
          // contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        // validator: (value) {
        //   if (value == null || value.isEmpty) {
        //     return '$label cannot be empty';
        //   }
        //   return null;
        // },
      ),
    );
  }
}
