// import 'dart:convert';

// import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class ImageCaptureScreen extends StatefulWidget {
//   const ImageCaptureScreen({super.key});

//   @override
//   ImageCaptureScreenState createState() => ImageCaptureScreenState();
// }

// class ImageCaptureScreenState extends State<ImageCaptureScreen> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _captureImage() async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(
//         source: ImageSource.camera,
//       );

//       if (pickedFile == null) {
//         print("No image captured.");
//         return;
//       }

//       final File imageFile = File(pickedFile.path);

//       setState(() {
//         _image = imageFile;
//       });

//       // ✅ Save to Gallery using image_gallery_saver_plus with proper error handling
//       final result = await ImageGallerySaverPlus.saveFile(pickedFile.path);
//       if (result == null || result['isSuccess'] == false) {
//         print("Failed to save image to gallery.");
//       } else {
//         print("Image saved successfully!");
//       }

//       // ✅ Upload Image with null safety
//       await _uploadImage(imageFile);
//     } catch (e) {
//       print("Error capturing image: $e");
//     }
//   }

//   Future<void> _uploadImage(File imageFile) async {
//     try {
//       var request = http.MultipartRequest(
//         'POST',
//         Uri.parse(
//           "https://staging.riseupkw.net/qofi/api/v1/driver/update/image",
//         ),
//       );
//       request.files.add(
//         await http.MultipartFile.fromPath('image', imageFile.path),
//       );

//       var response = await request.send();
//       if (response.statusCode == 200) {
//         final responseData = await response.stream.bytesToString();
//         final imageUrl = jsonDecode(responseData)['imageUrl'];
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString("saved_image_url", imageUrl);
//         print('Image uploaded & saved successfully');
//       } else {
//         print('Failed to upload image: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error uploading image: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 40,
//           backgroundColor: Colors.blueAccent, // Fallback color
//           backgroundImage:
//               _image != null
//                   ? FileImage(_image!)
//                   : null, // ✅ Show image inside avatar
//           child:
//               _image == null
//                   ? IconButton(
//                     icon: Icon(Icons.camera_alt, color: Colors.white),
//                     onPressed: _captureImage,
//                   )
//                   : null, // ✅ Remove button when image is present
//         ),
//       ],
//     );
//   }
// }
