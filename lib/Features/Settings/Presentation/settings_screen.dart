import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/features/settings/presentation/Widgets/profile_avatar.dart';

import 'widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            ProfileAvatar(),
            SizedBox(height: 24),
            SettingsTile(title: 'Edit Name'),
            SettingsTile(title: 'Edit Photo'),
            SettingsTile(title: 'Language', trailingText: 'English'),
          ],
        ),
      ),
    );
  }
}
