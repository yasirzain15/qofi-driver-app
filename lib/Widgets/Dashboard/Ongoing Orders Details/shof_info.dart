import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Model/order_details_model.dart';

class ShopInfo extends StatelessWidget {
  final DriverOrderDetails orderDetails;

  const ShopInfo({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shop Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(orderDetails.shopName, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              orderDetails.address,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
