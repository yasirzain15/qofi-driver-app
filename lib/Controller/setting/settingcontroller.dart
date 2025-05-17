import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:qufi_driver_app/Model/setting/settingmodel.dart';

class SettingsController {
  final SettingsModel model = SettingsModel();
  final ImagePicker _picker = ImagePicker();

  void updateName(String newName) {
    model.name = newName;
  }

  Future<void> updateImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      model.image = File(pickedFile.path);
    }
  }
}
