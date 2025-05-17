import 'package:flutter/material.dart';

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
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 30, child: Icon(Icons.person)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(driverName, style: Theme.of(context).textTheme.titleLarge),
                Text('Total Orders: $totalOrders'),
                Text('Completed: $completedCount | Ongoing: $ongoingCount'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
