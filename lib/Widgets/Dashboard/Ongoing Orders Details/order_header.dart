import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Model/order_details_model.dart';

class OrderHeader extends StatelessWidget {
  final DriverOrderDetails orderDetails;

  const OrderHeader({super.key, required this.orderDetails});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order Status',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    orderDetails.orderStatus,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${orderDetails.deliveryDay}, ${orderDetails.deliveryDate} at ${orderDetails.deliveryTime}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
