import 'dart:io';

class SettingsModel {
  String name;
  String currentPassword;

  File? image;

  SettingsModel({
    this.name = "John Doe",
    this.image,
    required this.currentPassword,
  });
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(currentPassword: json['password']);
  }
}
