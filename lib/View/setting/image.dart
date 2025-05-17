import 'package:gallery_saver/gallery_saver.dart';
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
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Save to Gallery
      await GallerySaver.saveImage(pickedFile.path);

      // Upload Image
      await _uploadImage(pickedFile.path);
    }
  }

  Future<void> _uploadImage(String imagePath) async {
    var request = http.MultipartRequest('POST', Uri.parse("YOUR_SERVER_URL"));
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Upload successful');
    } else {
      print('Upload failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Capture & Upload")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _captureImage,
            child: Text("Capture Image"),
          ),
          if (_image != null) Image.file(_image!),
        ],
      ),
    );
  }
}
