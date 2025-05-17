import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/setting/settingcontroller.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Model/setting/settingmodel.dart';
import 'package:qufi_driver_app/View/setting/image.dart';
import 'package:qufi_driver_app/Widgets/setting/edit_pasword.dart';

import '../../Widgets/setting/profileimage.dart';

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

  @override
  Widget build(BuildContext context) {
    SettingsModel model = controller.model;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,

        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text('Settings'),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),
          ImageCaptureScreen(),

          SizedBox(height: 10),
          Text(
            model.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          _buildSettingButton("Edit Name", _editName),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditPasswordScreen()),
              );
            },
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.white,
              child: ListTile(
                title: Text("Edit Password"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingButton(String label, VoidCallback onTap) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: ListTile(
        title: Text(label, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
