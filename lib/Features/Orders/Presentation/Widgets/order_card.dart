import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final String name;
  final String address;
  final String status;

  const OrderCard({
    super.key,
    required this.orderNumber,
    required this.name,
    required this.address,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        title: Text(
          'Order $orderNumber',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(color: AppColors.text)),
            Text(address, style: TextStyle(color: AppColors.text)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.pickedTag,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: const TextStyle(fontSize: 12, color: AppColors.text),
          ),
        ),
      ),
    );
  }
}
