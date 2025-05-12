import 'dart:io';

class SettingsModel {
  String name;
  String language;
  File? image;

  SettingsModel(
      {this.name = "John Doe", this.language = "English", this.image});
}
