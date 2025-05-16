import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'package:qufi_driver_app/Model/imagr_model.dart';

class ImageController {
  final ImageModel _imageModel = ImageModel();
  final ImagePicker _picker = ImagePicker();
  File? previousImage;

  /// Pick image from Camera
  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        previousImage = _imageModel.selectedImage; // Track previous image
        _imageModel.selectedImage = File(pickedFile.path);

        // Ensure UI refresh (if used inside StatefulWidget)
        if (_imageModel.selectedImage != null) {
          print("Selected Image Path: ${_imageModel.selectedImage!.path}");
        } else {
          print("No image selected.");
          return;
        }

        // Upload image and print URL
        String? uploadedUrl = await uploadImage(_imageModel.selectedImage!);
        if (uploadedUrl != null) {
          print("Uploaded Image URL: $uploadedUrl");
        } else {
          print("Image upload failed.");
        }
      } else {
        print("No image captured.");
      }
    } catch (e) {
      print("Error selecting image: $e");
    }
  }

  /// Upload image to backend and return URL

  Future<String?> uploadImage(File imageFile) async {
    try {
      // Extract filename dynamically from the selected image
      String fileName = path.basename(imageFile.path);

      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename:
              "/data/user/0/com.example.qufi_driver_app/cache/2c1e9c2a-cb57-4575-a863-d1cd04d14fc49113862706036517797.jpg", // Use actual filename
        ),
      });

      Response response = await Dio().post(
        "https://staging.riseupkw.net/qofi/api/v1/driver/update/image", // API endpoint
        data: formData,
        options: Options(
          headers: {
            "Authorization":
                "Bearer 366|gc4Uz96Y72nwR2ilI3gv5QYyYmuDDOiiBxD4LZSW24f2858a", // Ensure correct token format
            "Content-Type": "multipart/form-data",
          },
        ),
      );

      if (response.statusCode == 200) {
        var responseData = response.data;

        // Ensure response contains expected data
        if (responseData["success"] == true && responseData["data"] != null) {
          String uploadedUrl = responseData["data"]["image_url"];
          print("✅ Uploaded Image URL: $uploadedUrl");
          return uploadedUrl;
        } else {
          print("⚠️ Upload failed: ${responseData["message"]}");
          return null;
        }
      } else {
        print("❌ Server responded with status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❗ Error uploading image: $e");
      return null;
    }
  }

  // return the selected image**
  File? getSelectedImage() {
    return _imageModel.selectedImage;
  }

  /// Check if the image has changed
  bool isImageChanged() {
    if (previousImage == null || _imageModel.selectedImage == null)
      return false;
    return previousImage!.path != _imageModel.selectedImage!.path;
  }
}
