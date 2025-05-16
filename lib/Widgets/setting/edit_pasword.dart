import 'package:flutter/material.dart';

class EditPasswordScreen extends StatefulWidget {
  const EditPasswordScreen({super.key});

  @override
  EditPasswordScreenState createState() => EditPasswordScreenState();
}

class EditPasswordScreenState extends State<EditPasswordScreen> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void _saveChanges() {
    // Add logic to update password
    print("Current Password: ${currentPasswordController.text}");
    print("New Password: ${newPasswordController.text}");
    print("Confirm New Password: ${confirmPasswordController.text}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Password")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Current Password"),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "New Password"),
            ),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Confirm  New Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _saveChanges, child: Text("Save")),
          ],
        ),
      ),
    );
  }
}
