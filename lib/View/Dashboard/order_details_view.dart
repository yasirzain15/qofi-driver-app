import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/order_details_controller.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/customer_info.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/order_header.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/order_items.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/payment_info.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/shof_info.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Provider.of<OrderDetailsController>(
        context,
        listen: false,
      );
      controller.fetchOrderDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Order Details'),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      body: Consumer<OrderDetailsController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Text(
                controller.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (controller.orderDetails == null) {
            return const Center(child: Text('No order details available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderHeader(
                  orderDetails: controller.orderDetails!.driverOrderDetails,
                ),
                const SizedBox(height: 20),
                ShopInfo(
                  orderDetails: controller.orderDetails!.driverOrderDetails,
                ),
                const SizedBox(height: 20),
                OrderItems(
                  orderDetails: controller.orderDetails!.driverOrderDetails,
                ),
                const SizedBox(height: 20),
                CustomerInfo(
                  orderDetails: controller.orderDetails!.driverOrderDetails,
                ),
                const SizedBox(height: 20),
                PaymentInfo(
                  orderDetails: controller.orderDetails!.driverOrderDetails,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
