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
            // Ongoing Orders List
            ongoingController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount:
                      ongoingController
                          .ongoingOrders
                          ?.data
                          .driverOrders
                          .length ??
                      0,
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
                ),

            // Completed Orders List
            completedController.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                  itemCount: completedController.completedOrders.length,
                  itemBuilder: (context, index) {
                    final order = completedController.completedOrders[index];
                    return OrderCard(
                      orderNo: order.orderNo,
                      name: order.customerName,
                      address: order.orderAddress,
                      status: "Picked",
                    );
                  },
                ),
          ],
        ),
      ),
    );
  }
}
