import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageCaptureScreen extends StatefulWidget {
  @override
  _ImageCaptureScreenState createState() => _ImageCaptureScreenState();
}

class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
  String? _savedImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    fetchLatestImage(); // ✅ Load last stored image when app starts
  }

  /// ✅ Pick an image, edit & upload it
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    File originalImage = File(pickedFile.path);
    File compressedImage = await _compressImage(originalImage);

    await updateDriverImage(compressedImage);
  }

  /// ✅ Compress Image before Uploading
  Future<File> _compressImage(File imageFile) async {
    final dir = imageFile.parent.path;
    final targetPath = "$dir/compressed_${imageFile.path.split('/').last}";

    var result = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      targetPath,
      quality: 85,
    );

    return File(result!.path);
  }

  /// ✅ Upload Edited Image & Save URL
  Future<void> updateDriverImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://staging.riseupkw.net/qofi/api/v1/driver/update/image"),
    );
    print("🔹 Sending image update request...");
    print("🔹 Image Path: ${imageFile.path}");

    request.files.add(
      await http.MultipartFile.fromPath('image', imageFile.path),
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token == null || token.isEmpty) {
      print("❌ Missing token, cannot update image.");
      return;
    }

    request.headers["Authorization"] = "Bearer $token";

    var response = await request.send();
    var responseData = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(responseData);
      String imageUrl = jsonResponse["image_url"];
      print("✅ Image updated successfully: $imageUrl");

      setState(() {
        _savedImageUrl = imageUrl;
      });

      await prefs.setString(
        "saved_image_url",
        imageUrl,
      ); // ✅ Store updated image URL
      print("✅ Image updated successfully: $imageUrl");
    } else {
      print("❌ Failed to update image: ${response.statusCode}");
    }
  }

  /// ✅ Retrieve stored image OR fetch latest if none exist
  Future<void> fetchLatestImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedImageUrl = prefs.getString("saved_image_url");
    print("🔍 Stored Image URL: $savedImageUrl");

    if (savedImageUrl != null) {
      setState(() {
        _savedImageUrl = savedImageUrl;
      });
      return;
    }

    var response = await http.get(
      Uri.parse("https://staging.riseupkw.net/qofi/api/v1/driver/image"),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      String latestImageUrl = jsonResponse["image_url"];

      setState(() {
        _savedImageUrl = latestImageUrl;
      });

      await prefs.setString("saved_image_url", latestImageUrl);
    } else {
      print("❌ Failed to fetch latest image: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Profile Picture")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _savedImageUrl != null
              ? Image.network(_savedImageUrl!)
              : Text("No saved image found"),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.gallery),
            child: Text("Choose from Gallery"),
          ),
          ElevatedButton(
            onPressed: () => _pickImage(ImageSource.camera),
            child: Text("Take a Picture"),
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ImageCaptureScreen extends StatefulWidget {
//   @override
//   _ImageCaptureScreenState createState() => _ImageCaptureScreenState();
// }

// class _ImageCaptureScreenState extends State<ImageCaptureScreen> {
//   String? _savedImageUrl;
//   final ImagePicker _picker = ImagePicker();

//   @override
//   void initState() {
//     super.initState();
//     fetchLatestImage(); // ✅ Load the latest image from the API when the app starts
//   }

//   /// ✅ Pick an Image & Upload it to API
//   Future<void> _pickImage(ImageSource source) async {
//     final XFile? pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile == null) return;

//     File imageFile = File(pickedFile.path);
//     await uploadImage(imageFile);
//   }

//   /// ✅ Upload Image & Store URL from API Response
//   Future<void> uploadImage(File imageFile) async {
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse("https://staging.riseupkw.net/qofi/api/v1/driver/update/image"),
//     );

//     request.files.add(
//       await http.MultipartFile.fromPath('image', imageFile.path),
//     );

//     var response = await request.send();

//     if (response.statusCode == 200) {
//       var responseData = await response.stream.bytesToString();
//       var jsonResponse = json.decode(responseData);
//       String imageUrl = jsonResponse["image_url"];

//       setState(() {
//         _savedImageUrl = imageUrl;
//       });

//       // ✅ Save latest image URL in SharedPreferences
//       final SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setString("saved_image_url", imageUrl);

//       print("Image updated successfully: $imageUrl");
//     } else {
//       print("Failed to update image: ${response.statusCode}");
//     }
//   }

//   /// ✅ Fetch the Latest Image from API when App Starts
//   Future<void> fetchLatestImage() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? savedImageUrl = prefs.getString("saved_image_url");

//     if (savedImageUrl != null) {
//       setState(() {
//         _savedImageUrl = savedImageUrl;
//       });
//     } else {
//       var response = await http.get(
//         Uri.parse("https://staging.riseupkw.net/qofi/api/v1/driver/image"),
//       );

//       if (response.statusCode == 200) {
//         var jsonResponse = json.decode(response.body);
//         String latestImageUrl = jsonResponse["image_url"];

//         setState(() {
//           _savedImageUrl = latestImageUrl;
//         });

//         await prefs.setString("saved_image_url", latestImageUrl);
//       } else {
//         print("Failed to fetch latest image: ${response.statusCode}");
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Select Profile Picture")),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _savedImageUrl != null
//               ? Image.network(_savedImageUrl!)
//               : Text("No saved image found"),
//           ElevatedButton(
//             onPressed: () => _pickImage(ImageSource.gallery),
//             child: Text("Choose from Gallery"),
//           ),
//           ElevatedButton(
//             onPressed: () => _pickImage(ImageSource.camera),
//             child: Text("Take a Picture"),
//           ),
//         ],
//       ),
//     );
//   }
// }
