import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageCaptureScreen extends StatefulWidget {
  final String? savedImagePath; // Receive saved image path from SettingsScreen

  const ImageCaptureScreen({super.key, this.savedImagePath});

  @override
  ImageCaptureScreenState createState() => ImageCaptureScreenState();
}

class ImageCaptureScreenState extends State<ImageCaptureScreen> {
  File? _image;
  String? _savedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }

  /// ✅ Load saved image path from SharedPreferences
  Future<void> _loadSavedImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString("saved_image_path");

    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _savedImagePath = imagePath;
      });
    } else {
      if (kDebugMode) {
        print("⚠ No saved image found.");
      }
    }
  }

  /// ✅ Capture, Save Image Locally, and Store Path
  Future<void> _captureImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) {
        if (kDebugMode) print("⚠ No image captured.");
        return;
      }

      final File imageFile = File(pickedFile.path);

      setState(() {
        _image = imageFile;
        _savedImagePath = pickedFile.path;
      });

      // ✅ Save image path to SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("saved_image_path", pickedFile.path);
      if (kDebugMode) {
        print("✅ Image Path Saved: ${prefs.getString("saved_image_path")}");
      }

      // ✅ Save to gallery
      final result = await ImageGallerySaverPlus.saveFile(pickedFile.path);
      if (result == null || result['isSuccess'] == false) {
        if (kDebugMode) print("❌ Failed to save image to gallery.");
      } else {
        if (kDebugMode) print("✅ Image saved to gallery successfully!");
      }
    } catch (e) {
      if (kDebugMode) print("❌ Error capturing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blueAccent,
          backgroundImage:
              _image != null
                  ? FileImage(_image!)
                  : _savedImagePath != null &&
                      File(_savedImagePath!).existsSync()
                  ? FileImage(File(_savedImagePath!))
                  : const AssetImage(
                    "assets/default_profile.png",
                  ), // ✅ Fallback Image
          child:
              _image == null &&
                      (_savedImagePath == null || _savedImagePath!.isEmpty)
                  ? IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _captureImage,
                  )
                  : null, // ✅ Hide button when an image exists
        ),
      ],
    );
  }
}
