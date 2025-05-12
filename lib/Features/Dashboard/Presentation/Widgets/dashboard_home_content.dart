import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'profile_header.dart';
import 'order_stats_row.dart';
import 'ongoing_order_card.dart';

class DashboardHomeContent extends StatelessWidget {
  const DashboardHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ProfileHeader(),
            SizedBox(height: 24),
            OrderStatsRow(),
            SizedBox(height: 24),
            Text(
              'Ongoing',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
            SizedBox(height: 12),
            OngoingOrderCard(),
          ],
        ),
      ),
    );
  }
}
