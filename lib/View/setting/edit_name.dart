// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';

import 'package:qufi_driver_app/View/setting/settingview.dart';
import 'package:qufi_driver_app/Widgets/Login/custombutton.dart';
import 'package:qufi_driver_app/Widgets/Login/inputfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  void showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void updateName() async {
    if (nameController.text.trim().isEmpty) {
      showError("Name cannot be empty!"); // ✅ Show error for empty name
      return;
    }

    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      "name",
      nameController.text.trim(),
    ); // ✅ Save name locally

    print("✅ Saved Name Locally: ${prefs.getString("name")}"); // ✅ Debugging

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "✅ Name updated successfully!", // ✅ Use correct variable
        ),
      ),
    );

    setState(() => isLoading = false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen()),
    ).then((_) {});
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
              text: isLoading ? 'Saving' : 'Save',
              isLoading: isLoading,
              onPressed: isLoading ? null : updateName,
            ),
          ],
        ),
      ),
    );
  }
}
