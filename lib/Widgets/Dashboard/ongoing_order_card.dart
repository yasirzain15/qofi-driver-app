import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/ongoing_orders_controller.dart';
import 'package:qufi_driver_app/Model/order_model.dart';
import 'package:qufi_driver_app/View/Dashboard/order_details_view.dart';

class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;
  final Function(String) onPickPressed;

  const OrdersList({
    super.key,
    required this.orders,
    required this.onPickPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ongoingController = Provider.of<OngoingOrdersController>(context);

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        // Find the matching order in ongoingController's data
        final driverOrder = ongoingController.ongoingOrders?.data.driverOrders
            .firstWhere(
              (o) => o.orderNo == order.orderNo,
              orElse:
                  () =>
                      throw Exception(
                        'Order not found',
                      ), // Throw exception if not found
            );

        return GestureDetector(
          onTap: () {
            if (driverOrder == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order details not available')),
              );
              return;
            }

            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => OrderDetailsView(
                      orderNo: order.orderNo,
                      orderId:
                          driverOrder.orderId, // Use orderId from ongoing order
                      token:
                          'Bearer 507|ZbWZSMD3HrWYCUlvyiJLu7aoUxUwbUYRQ9DbnXWp6447eddd',
                    ),
              ),
            );
          },
          child: Card(
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              title: Text(
                'Order #${order.orderNo}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(driverOrder?.customerName ?? 'No customer name'),
                  Text(
                    driverOrder?.orderAddress ?? 'No address',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(.4),
                ),
                child: const Text("Picked"),
              ),
            ),
          ),
        );
      },
    );
  }
}
