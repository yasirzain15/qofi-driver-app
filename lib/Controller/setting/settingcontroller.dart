import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageController {
  final ImagePicker _picker = ImagePicker();

  Future<File?> captureImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile == null) {
        if (kDebugMode) print("No image captured.");
        return null;
      }

      final File imageFile = File(pickedFile.path);

      final result = await ImageGallerySaverPlus.saveFile(pickedFile.path);
      if (result == null || result['isSuccess'] == false) {
        if (kDebugMode) print("Failed to save image to gallery.");
      }

      return imageFile;
    } catch (e) {
      if (kDebugMode) print("Error capturing image: $e");
      return null;
    }
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          "https://staging.riseupkw.net/qofi/api/v1/driver/update/image",
        ),
      );
      request.headers.addAll({
        "Authorization":
            "Bearer 404|wO0KxcxpYYyO0TptoDe3mwkygZuGDfZnHECmbLfl98c8cd6b",
        "Content-Type": "multipart/form-data",
      });

      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        if (kDebugMode) {
          print("🔍 Full API Response: $responseData");
        }
        Map<String, dynamic> data = jsonDecode(responseData);

        if (data.containsKey('data') && data['data'].containsKey('image')) {
          String imageUrl = data['data']['image'];
          if (kDebugMode) {
            print("🔍 Extracted Image URL from API Response: $imageUrl");
          }
          await _saveImageUrl(imageUrl);
          if (kDebugMode) {
            print("⚠ 'image' key missing in 'data' object.");
          } // Store image URL
          return imageUrl; // ✅ Ensure a valid return
        } else {
          if (kDebugMode) {
            print("⚠ Upload succeeded, but no image URL returned.");
          }
          return null; // ✅ Explicit return
        }
      } else {
        if (kDebugMode) {
          print("❌ Upload failed. Status code: ${response.statusCode}");
        }
        return null; // ✅ Explicit return
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error uploading image: $e");
      }
      return null; // ✅ Explicit return on exception
    }
  }

  Future<void> _saveImageUrl(String imageUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_image_url", imageUrl);
    String? storedUrl = prefs.getString("saved_image_url");
    if (kDebugMode) {
      print("🔍 Retrieved Stored Image URL: $storedUrl");
    }
    if (kDebugMode) {
      print("🔍 Saved Image URL: $storedUrl");
    }
  }

  Future<String?> getSavedImageUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUrl = prefs.getString("saved_image_url");
    if (kDebugMode) {
      print("🔍 Retrieved Image URL: $savedUrl");
    }

    return savedUrl;
  }
}
