import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? trailingText;

  const SettingsTile({super.key, required this.title, this.trailingText});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: TextStyle(color: AppColors.text)),
      trailing:
          trailingText != null
              ? Text(
                trailingText!,
                style: const TextStyle(color: AppColors.subText),
              )
              : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {},
    );
  }
}
