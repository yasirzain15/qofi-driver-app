// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Model/setting/edit_name_model.dart';
import 'package:qufi_driver_app/View/setting/settingview.dart';
import 'package:qufi_driver_app/Widgets/Login/custombutton.dart';
import 'package:qufi_driver_app/Widgets/Login/inputfield.dart';

import '../../Controller/setting/edit_name_controller.dart';

class NameView extends StatefulWidget {
  const NameView({super.key});

  @override
  NameViewState createState() => NameViewState();
}

class NameViewState extends State<NameView> {
  final TextEditingController nameController = TextEditingController();
  final NameController nameControllerInstance = NameController();
  bool isLoading = false;

  void updateName() async {
    setState(() => isLoading = true);
    if (nameController.text.trim().isEmpty) {
      showError("Name cannot be empty!");
      return;
    }

    setState(() => isLoading = true);

    String token = '411|jHgzQ9z7qHbetzLWsUxXWngjZ4RWFWmr8RcVNfDBac453dad';
    NameModel nameModel = NameModel(name: nameController.text.trim());

    String responseMessage = await nameControllerInstance.updateName(
      nameModel,
      token,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(responseMessage)));

    if (responseMessage.contains("Name updated successfully")) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }

    setState(() => isLoading = false);
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Update Name'),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            InputField(controller: nameController, label: 'New Name'),
            SizedBox(height: 20),
            CustomButton(
              text: isLoading ? 'Saving...' : 'Save',
              onPressed: isLoading ? null : updateName,
            ),
          ],
        ),
      ),
    );
  }
}
