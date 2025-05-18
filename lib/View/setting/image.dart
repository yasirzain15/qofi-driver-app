import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

class ImageCaptureScreen extends StatefulWidget {
  const ImageCaptureScreen({super.key});

  @override
  ImageCaptureScreenState createState() => ImageCaptureScreenState();
}

class ImageCaptureScreenState extends State<ImageCaptureScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        // ✅ Save to Gallery using image_gallery_saver_plus
        await ImageGallerySaverPlus.saveFile(pickedFile.path);

        // ✅ Upload Image
        await _uploadImage(File(pickedFile.path));
      } else {
        print("No image captured.");
      }
    } catch (e) {
      print("Error capturing image: $e");
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("YOUR_SERVER_URL"));
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        print('Upload successful');
      } else {
        print('Upload failed');
      }
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blueAccent,
          child: IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.white),
            onPressed: _captureImage,
          ),
        ),
        SizedBox(height: 20),
        if (_image != null) Image.file(_image!), // Display image preview
      ],
    );
  }
}
