import 'package:http/http.dart' as http;
import 'dart:io';

import 'dart:convert';

class ImageService {
  static Future<String?> uploadImage(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://your-server.com/api/upload'),
      );

      // Add headers (authentication, content type)
      request.headers.addAll({
        "Authorization": "Bearer YOUR_TOKEN_HERE", // Replace with actual token
        "Content-Type": "multipart/form-data",
      });

      // Attach image file
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      // Send request and handle response
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseBody);
        String imageUrl = jsonResponse['image_url']; // Extract image URL
        print("Uploaded Image URL: $imageUrl");
        return imageUrl;
      } else {
        print("Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("Upload Error: $e");
    }
    return null;
  }
}
