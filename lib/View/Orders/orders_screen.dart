import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/completed_orders_controller.dart';
import 'package:qufi_driver_app/Controller/ongoing_orders_controller.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/orders_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ongoingController = Provider.of<OngoingOrdersController>(context);
    final completedController = Provider.of<CompletedOrdersController>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          title: const Text("Orders"),
          bottom: const TabBar(
            indicatorColor: Colors.blue,
            tabs: [Tab(text: "Ongoing"), Tab(text: "Completed")],
          ),
        ),
        body: TabBarView(
          children: [
            // Ongoing Orders Tab
            ongoingController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : (ongoingController
                        .ongoingOrders
                        ?.data
                        .driverOrders
                        .isNotEmpty ??
                    false)
                ? ListView.builder(
                  itemCount:
                      ongoingController.ongoingOrders!.data.driverOrders.length,
                  itemBuilder: (context, index) {
                    final order =
                        ongoingController
                            .ongoingOrders!
                            .data
                            .driverOrders[index];
                    return OrderCard(
                      orderNo: order.orderNo,
                      name: order.customerName,
                      address: order.orderAddress,
                      status: "Picked",
                    );
                  },
                )
                : _buildEmptyState(
                  icon: Icons.assignment_outlined,
                  title: "No Ongoing Orders",
                  message: "You currently don't have any ongoing orders.",
                ),

            // Completed Orders Tab
            completedController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : (completedController.completedOrders.isNotEmpty)
                ? ListView.builder(
                  itemCount: completedController.completedOrders.length,
                  itemBuilder: (context, index) {
                    final order = completedController.completedOrders[index];
                    return OrderCard(
                      orderNo: order.orderNo,
                      name: order.customerName,
                      address: order.orderAddress,
                      status: "Completed",
                    );
                  },
                )
                : _buildEmptyState(
                  icon: Icons.assignment_turned_in_outlined,
                  title: "No Completed Orders",
                  message: "You haven't completed any orders yet.",
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
