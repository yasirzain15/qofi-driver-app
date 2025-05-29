import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qufi_driver_app/Core/Constants/api.dart';

class ImageService {
  Future<Map<String, dynamic>> uploadImage(File imageFile, String token) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.updatedriverimage),
      );
      request.headers.addAll({'Authorization': 'Bearer $token'});
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        String imageUrl = jsonResponse["image_url"];

        await _saveImageLocally(imageUrl);
        return {
          'success': true,
          'message': 'Image updated successfully!',
          'imageUrl': imageUrl,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to update image: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error occurred: $e'};
    }
  }

  Future<void> _saveImageLocally(String imageUrl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("saved_image_url", imageUrl);
  }

  Future<String?> getLocalImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("saved_image_url");
  }
}
