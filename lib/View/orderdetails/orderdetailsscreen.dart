import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/ongoing_orders_controller.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Model/ongoing_orders_model.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  void initState() {
    super.initState();
    final controller = Provider.of<OngoingOrdersController>(
      context,
      listen: false,
    );
    controller.fetchOngoingOrders("your_token_here"); // Replace with real token
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<OngoingOrdersController>(context);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Orders', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.background,
        ),
        body:
            controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : controller.ongoingOrders == null
                ? Center(
                  child: Text("Failed to load orders\n${controller.error}"),
                )
                : Column(
                  children: [
                    _buildTabBar(controller),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildTabContent(0, controller),
                          _buildTabContent(1, controller),
                          _buildTabContent(2, controller),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildTabBar(OngoingOrdersController controller) {
    return TabBar(
      indicatorColor: Colors.blue,
      labelColor: Colors.black,
      tabs: [
        _buildTab(
          controller.ongoingOrders!.data.orderCount.toString(),
          "Ongoing",
        ),
        _buildTab("0", "Completed"),
        _buildTab(
          controller.ongoingOrders!.data.driverOrders.length.toString(),
          "All",
        ),
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

  Widget _buildTabContent(int tabIndex, OngoingOrdersController controller) {
    List<DriverOrder> orders;

    switch (tabIndex) {
      case 0:
        orders = controller.ongoingOrders!.data.driverOrders;
        break;
      case 1:
        orders = []; // Completed Orders logic (if available)
        break;
      case 2:
        orders = controller.ongoingOrders!.data.driverOrders;
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
            ["Ongoing Orders", "Completed Orders", "All Orders"][tabIndex],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 12),
          _buildOrderList(orders),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<DriverOrder> orders) {
    return Column(
      children: orders.map((order) => _buildOrderCard(order)).toList(),
    );
  }

  Widget _buildOrderCard(DriverOrder order) {
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
                  order.orderNo,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Ongoing", // You can use `order.status` if available
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ],
            ),
            SizedBox(height: 6),
            Text(
              order.customerName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6),
            Text(order.orderAddress, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
