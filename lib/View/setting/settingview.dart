import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qufi_driver_app/View/setting/image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qufi_driver_app/Controller/setting/edit_name_controller.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';

import 'package:qufi_driver_app/View/setting/edit_name.dart';
import 'package:qufi_driver_app/Widgets/setting/edit_pasword.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final NameController _nameController = NameController();
  String? driverName;
  String? _savedImagePath; // ✅ Store local file path instead of a URL

  @override
  void initState() {
    super.initState();
    _loadDriverName();
    _loadSavedImage();
  }

  /// ✅ Load saved driver name
  Future<void> _loadDriverName() async {
    String? name = await _nameController.getDriverName();
    print("🔍 Retrieved Driver Name: $name");
    if (!mounted) return;
    setState(() {
      driverName = name ?? '';
    });
  }

  /// ✅ Load saved image from SharedPreferences (local path)
  Future<void> _loadSavedImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString("saved_image_path");

    if (kDebugMode) {
      print("🔍 Retrieved Image Path in Settings: $imagePath");
    }

    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _savedImagePath = imagePath;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: const Text('Settings'),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),

          /// ✅ Display Image with Persistent Storage
          ImageCaptureScreen(
            savedImagePath: _savedImagePath,
          ), // ✅ Pass local file path

          const SizedBox(height: 10),
          Text(
            driverName ?? "",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 30),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NameView()),
              ).then((_) => _loadDriverName());
            },
            child: const Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: ListTile(
                title: Text("Edit Name"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),

          /// ✅ Edit Password Button
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PasswordView()),
              );
            },
            child: const Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: ListTile(
                title: Text("Edit Password"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
