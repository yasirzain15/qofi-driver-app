import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Model/ongoing_orders_model.dart';

class OngoingOrderTile extends StatelessWidget {
  final DriverOrder order;

  const OngoingOrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        title: Text(
          'Order #${order.orderNo}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              order.customerName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(order.orderAddress),
          ],
        ),
        trailing: const Chip(
          label: Text("Picked"),
          backgroundColor: Colors.green,
        ),
      ),
    );
  }
}
