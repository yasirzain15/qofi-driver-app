import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/View/setting/settingview.dart';
import 'package:qufi_driver_app/Widgets/Login/custombutton.dart';
import 'package:qufi_driver_app/Widgets/Login/inputfield.dart';

import '../../Controller/setting/edit_name_controller.dart';

class NameView extends StatefulWidget {
  final String token; // ✅ Token required for API calls

  const NameView({super.key, required this.token});

  @override
  NameViewState createState() => NameViewState();
}

class NameViewState extends State<NameView> {
  final TextEditingController nameController = TextEditingController();
  final NameService nameService = NameService();
  bool isLoading = false;

  void showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> updateName() async {
    if (nameController.text.trim().isEmpty) {
      showError("Name cannot be empty!");
      return;
    }

    setState(() => isLoading = true);

    String newName = nameController.text.trim();
    Map<String, dynamic> result = await nameService.updateUserName(
      newName,
      widget.token,
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result['message'])));

    if (result['success']) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }

    setState(() => isLoading = false);
  }

  Future<void> loadLocalName() async {
    String? localName = await nameService.getLocalUserName();
    if (localName != null) {
      setState(() => nameController.text = localName);
    }
  }

  @override
  void initState() {
    super.initState();
    loadLocalName();
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
