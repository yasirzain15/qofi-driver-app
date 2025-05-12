import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Model/setting/settingmodel.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key, required this.model});

  final SettingsModel model;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 100,
      backgroundImage:
          model.image != null
              ? FileImage(model.image!)
              : AssetImage("assets/profile.png") as ImageProvider,
    );
  }
}
