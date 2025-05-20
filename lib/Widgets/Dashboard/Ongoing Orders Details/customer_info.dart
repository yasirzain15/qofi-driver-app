import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Model/order_details_model.dart';

class CustomerInfo extends StatelessWidget {
  final DriverOrderDetails orderDetails;

  const CustomerInfo({super.key, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              orderDetails.customerName,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 8),
                Text(
                  orderDetails.customerPhone,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
