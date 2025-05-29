// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';

import 'package:qufi_driver_app/Services/auth_services.dart';
import 'package:qufi_driver_app/Widgets/Login/custombutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/View/setting/edit_name.dart';
import 'package:qufi_driver_app/Widgets/setting/edit_pasword.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String name = '';
  String username = '';
  String image = '';
  Uint8List? imageBytes;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    getStoredImage();
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> getStoredImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("saved_image_url");
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null) return;

    final String imagePath = pickedFile.path;

    setState(() {
      image = imagePath; // ✅ Update UI instantly
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("updated_image_path", imagePath);

    // ✅ Save to gallery if taken from camera
    if (source == ImageSource.camera) {
      await ImageGallerySaverPlus.saveFile(imagePath);
    }
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('name') ?? "Driver";
      username = prefs.getString('username') ?? "DefaultUsername";
      image = prefs.getString("saved_image_url") ?? ""; //
      // ✅ Check for user-updated image first, fallback to API image
      image =
          prefs.getString('updated_image_path') ??
          prefs.getString('api_image') ??
          "";
      // image = prefs.getString('image') ?? ""; // ✅ Show stored image
    });

    if (kDebugMode) {
      print("✅ Loaded Name: $name");
      print("✅ Loaded Username: $username");
      print("✅ Loaded Image URL: $image");
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

          GestureDetector(
            onTap: () => _showImagePicker(context),
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  image.isNotEmpty
                      ? (image.startsWith("http")
                          ? NetworkImage(image)
                          : FileImage(File(image)))
                      : AssetImage("assets/default_profile.png"),
            ),
          ),

          //   child: CircleAvatar(
          //     radius: 50,
          //     backgroundImage:
          //         image.isNotEmpty
          //             ? (image.startsWith("http")
          //                 ? NetworkImage(image) as ImageProvider<Object>
          //                 : FileImage(File(image)) as ImageProvider<Object>)
          //             : const AssetImage("assets/default_profile.png"),
          //   ),
          // ),
          SizedBox(height: 10),

          Text(
            " ${name.isNotEmpty ? name : "Not Available"}",
            style: TextStyle(fontSize: 18),
          ),

          Text(
            " ${username.isNotEmpty ? username : "Not Available"}",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => NameView(
                        token:
                            "577|hCQkCcXVHaA7108CTceQgDLIRftiTfjl5rQMSMFp886f56b0",
                      ),
                ),
              ).then((_) => _loadUserData()); // ✅ Refresh name after edit
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
          SizedBox(height: 50),
          CustomButton(
            text: "Logout",

            onPressed: () => AuthService().logout(context),
          ),
        ],
      ),
    );
  }
}
