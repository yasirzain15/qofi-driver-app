import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Model/order_model.dart';

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
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            title: Text('Order #${order.orderNo}'),
            subtitle: Text(order.status),
            trailing: IconButton(
              icon: Icon(
                order.picked ? Icons.check_box : Icons.check_box_outline_blank,
                color: Colors.blue,
              ),
              onPressed: () => onPickPressed(order.orderNo),
            ),
          ),
        );
      },
    );
  }
}
