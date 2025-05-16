import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/ongoing_orders_controller.dart';

class OngoingOrdersScreen extends StatelessWidget {
  const OngoingOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OngoingOrdersController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ongoing Orders')),
      body:
          controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.ongoingOrders == null
              ? const Center(child: Text('No data found.'))
              : ListView.builder(
                itemCount: controller.ongoingOrders!.data.driverOrders.length,
                itemBuilder: (context, index) {
                  final order =
                      controller.ongoingOrders!.data.driverOrders[index];
                  return ListTile(
                    title: Text('Order #${order.orderNo}'),
                    subtitle: Text(order.customerName),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  );
                },
              ),
    );
  }
}
