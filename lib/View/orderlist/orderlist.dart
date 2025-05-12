import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/orderlist/orderlistcontroller.dart';
import 'package:qufi_driver_app/Model/orderdeatils/orderdetailsmodel.dart';

class OrdersScreen extends StatelessWidget {
  final OrderController controller = OrderController();

  OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          bottom: TabBar(tabs: [Tab(text: 'Ongoing'), Tab(text: 'Completed')]),
        ),
        body: TabBarView(
          children: [
            OrdersList(controller.ongoingOrders),
            OrdersList(controller.completedOrders),
          ],
        ),
      ),
    );
  }
}

class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;

  const OrdersList(this.orders, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order #${orders[index].orderId}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      orders[index].status,
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  'Customer: ${orders[index].customer}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Address: ${orders[index].address}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
