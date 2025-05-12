import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/orderdetails/orderdetail.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';

import 'package:qufi_driver_app/Model/orderdeatils/orderdetailsmodel.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderController controller = OrderController();

  @override
  void initState() {
    super.initState();
    controller
        .initializeOrders(); // Ensuring data is available before UI builds
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Orders', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.background,
        ),
        body: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildTabContent(0), // Completed Orders
                  _buildTabContent(1), // Ongoing Orders
                  _buildTabContent(2), //  Orders
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      indicatorColor: Colors.blue,
      labelColor: Colors.black,
      tabs: [
        _buildTab(controller.completedCount.toString(), "Orders"),
        _buildTab(controller.ongoingCount.toString(), "Completed"),
        _buildTab(controller.totalOrders.toString(), "Ongoing"),
      ],
    );
  }

  Widget _buildTab(String count, String label) {
    return SizedBox(
      height: 60,
      child: Tab(
        child: Column(
          children: [
            Text(
              count,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(int tabIndex) {
    List<OrderModel> orders;

    // Determine the correct data for each tab
    switch (tabIndex) {
      case 0:
        orders = controller.getCompletedOrders();
        break;
      case 1:
        orders = controller.getOngoingOrders();
        break;
      case 2:
        orders = controller.getOrders();
        break;
      default:
        orders = [];
    }

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.tabNames[tabIndex], // Dynamically updates header
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 12),
          _buildOrderList(orders),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<OrderModel> orders) {
    return Column(
      children: orders.map((order) => _buildOrderCard(order)).toList(),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Card(
      color: AppColors.card,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.orderId,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  order.status,
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              order.customer,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(order.address, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
