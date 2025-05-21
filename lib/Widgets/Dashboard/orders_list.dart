import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/ongoing_orders_controller.dart';
import 'package:qufi_driver_app/Model/order_model.dart';

class OrdersList extends StatefulWidget {
  final List<OrderModel> orders;
  final Function(String) onPickPressed;

  const OrdersList({
    super.key,
    required this.orders,
    required this.onPickPressed,
  });

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    final ongoingController = Provider.of<OngoingOrdersController>(context);
    return ListView.builder(
      itemCount: widget.orders.length,
      itemBuilder: (context, index) {
        final order = widget.orders[index];
        return Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            title: Text('Order #${order.orderNo}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ongoingController
                          .ongoingOrders
                          ?.data
                          .driverOrders[0]
                          .customerName
                      as String,
                ),
                Text(
                  ongoingController
                          .ongoingOrders
                          ?.data
                          .driverOrders[0]
                          .orderAddress
                      as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            trailing: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(.4),
              ),
              child: Text("Picked"),
            ),
          ),
        );
      },
    );
  }
}
