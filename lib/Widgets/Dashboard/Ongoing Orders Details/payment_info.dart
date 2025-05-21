import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Model/order_details_model.dart';

class PaymentInfo extends StatelessWidget {
  final DriverOrderDetails orderDetails;

  const PaymentInfo({super.key, required this.orderDetails});

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
              'Payment Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Method:'),
                Text(
                  orderDetails.paymentMethod,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Status:'),
                Chip(
                  label: Text(
                    orderDetails.paymentStatus,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor:
                      orderDetails.paymentStatus == "Pending"
                          ? Colors.orange
                          : Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
