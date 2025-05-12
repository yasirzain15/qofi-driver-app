import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/setting/settingcontroller.dart';
import 'package:qufi_driver_app/Model/setting/settingmodel.dart';

import 'Widgets/profileimage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final SettingsController controller = SettingsController();

  void _editName() {
    TextEditingController controllerInput = TextEditingController(
      text: controller.model.name,
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: TextField(controller: controllerInput),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  setState(() => controller.updateName(controllerInput.text));
                  Navigator.pop(context);
                },
                child: Text("Save"),
              ),
            ],
          ),
    );
  }

  void _editLanguage() {
    List<String> languages = ["English", "French", "Spanish", "German"];
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  languages
                      .map(
                        (lang) => ListTile(
                          title: Text(lang, style: TextStyle(fontSize: 16)),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            setState(() => controller.updateLanguage(lang));
                            Navigator.pop(context);
                          },
                        ),
                      )
                      .toList(),
            ),
          ),
    );
  }

  void _pickImage() async {
    await controller.updateImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SettingsModel model = controller.model;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(onTap: () {}, child: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        children: [
          ProfileImage(model: model),
          SizedBox(height: 10),
          Text(
            model.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          _buildSettingButton("Edit Name", _editName),
          _buildSettingButton("Edit Photo", _pickImage),
          _buildLanguageSelector("Language", model.language, _editLanguage),
        ],
      ),
    );
  }

  Widget _buildSettingButton(String label, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      child: ListTile(
        title: Text(label, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLanguageSelector(
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
      ),
      child: ListTile(
        title: Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value, style: TextStyle(fontSize: 16)),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
