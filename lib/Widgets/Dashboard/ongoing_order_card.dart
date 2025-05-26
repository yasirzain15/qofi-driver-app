import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/ongoing_orders_controller.dart';
import 'package:qufi_driver_app/Controller/order_details_controller.dart';
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
    final OrderDetailsController orderDetailsController =
        Provider.of<OrderDetailsController>(context, listen: false);
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => OrderDetailsView(
                      orderId:
                          orderDetailsController
                                  .orderDetails
                                  ?.driverOrderDetails
                                  .orderId
                              as int,
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
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                  color: Colors.grey.withOpacity(.4),
                ),
                child: Text("Picked"),
              ),
              // trailing: IconButton(
              //   icon: Icon(
              //     order.picked ? Icons.check_box : Icons.check_box_outline_blank,
              //     color: Colors.blue,
              //   ),
              //   onPressed: () => onPickPressed(order.orderNo),
              // ),
            ),
          ),
        );
      },
    );
  }
}
