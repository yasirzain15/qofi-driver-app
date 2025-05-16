import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/image_controller.dart';

class ProfileImageView extends StatefulWidget {
  const ProfileImageView({super.key});

  @override
  ProfileImageViewState createState() => ProfileImageViewState();
}

class ProfileImageViewState extends State<ProfileImageView> {
  final ImageController _imageController = ImageController();

  @override
  Widget build(BuildContext context) {
    File? imageFile = _imageController.getSelectedImage();

    return GestureDetector(
      onTap: () async {
        await _imageController.pickImage();
        setState(() {}); // Refresh UI after selecting image
      },
      child: CircleAvatar(
        radius: 50,
        backgroundImage: imageFile != null ? FileImage(imageFile) : null,
        child:
            imageFile == null
                ? Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                : null,
      ),
    );
  }
}
