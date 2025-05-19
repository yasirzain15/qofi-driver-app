import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/completed_orders_controller.dart';

class CompletedOrdersScreen extends StatelessWidget {
  const CompletedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CompletedOrdersController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Completed Orders')),
      body:
          controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.completedOrders.isEmpty
              ? const Center(child: Text('No completed orders.'))
              : ListView.builder(
                itemCount: controller.completedOrders.length,
                itemBuilder: (context, index) {
                  final order = controller.completedOrders[index];
                  return ListTile(
                    title: Text('Order #${order.orderNo}'),
                    subtitle: Text(order.customerName),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  );
                },
              ),
    );
  }
}
