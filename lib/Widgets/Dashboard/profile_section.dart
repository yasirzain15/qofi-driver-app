import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Widgets/setting/profileimage.dart';

class ProfileSection extends StatelessWidget {
  final String driverName;
  final int totalOrders, completedCount, ongoingCount;

  const ProfileSection({
    super.key,
    required this.driverName,
    required this.totalOrders,
    required this.completedCount,
    required this.ongoingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            SizedBox(height: 10),
            Text(
              "John Doe",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
