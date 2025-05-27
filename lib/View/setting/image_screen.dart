// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class ImageCaptureScreen extends StatefulWidget {
  final String?
  savedImagePath; // ✅ Receive the current image from SettingsScreen

  const ImageCaptureScreen({super.key, this.savedImagePath});

  @override
  ImageCaptureScreenState createState() => ImageCaptureScreenState();
}

class ImageCaptureScreenState extends State<ImageCaptureScreen> {
  String? _savedImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadSavedImage();

    // ✅ Open image picker bottom sheet immediately when screen loads
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _showImagePicker(context),
    );
  }

  /// ✅ Load the saved image from SharedPreferences
  Future<void> _loadSavedImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _savedImagePath =
        prefs.getString("updated_image_path") ?? widget.savedImagePath;

    if (_savedImagePath != null && File(_savedImagePath!).existsSync()) {
      setState(() {}); // ✅ Refresh UI when image exists
    }
  }

  /// ✅ Show bottom sheet with camera & gallery options
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

  /// ✅ Pick an image, save it locally, and return the updated path
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    final String imagePath = pickedFile.path;

    setState(() {
      _savedImagePath = imagePath;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("updated_image_path", imagePath);

    // ✅ Save to gallery if taken from camera
    if (source == ImageSource.camera) {
      await ImageGallerySaverPlus.saveFile(imagePath);
    }

    // ✅ Pass updated image back to SettingsScreen
    Navigator.pop(context, imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Profile Picture")),
      body: const Center(
        child: Text("Choose an image from the gallery or camera."),
      ),
    );
  }
}
