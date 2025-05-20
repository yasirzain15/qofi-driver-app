import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Controller/order_details_controller.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Model/order_details_model.dart';
import 'package:provider/provider.dart';

class OrderDetailsView extends StatefulWidget {
  const OrderDetailsView({super.key});

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  @override
  void initState() {
    super.initState();
    final controller = Provider.of<OrderDetailsController>(
      context,
      listen: false,
    );
    controller.fetchOrderDetails();
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
                _buildOrderHeader(controller.orderDetails!),
                const SizedBox(height: 20),
                _buildShopInfo(controller.orderDetails!),
                const SizedBox(height: 20),
                _buildOrderItems(controller.orderDetails!),
                const SizedBox(height: 20),
                _buildCustomerInfo(controller.orderDetails!),
                const SizedBox(height: 20),
                _buildPaymentInfo(controller.orderDetails!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader(OrderDetailsModel orderDetails) {
    return Card(
      color: AppColors.background,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${orderDetails.driverOrderDetails.orderNo}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text(
                    orderDetails.driverOrderDetails.paymentStatus,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor:
                      orderDetails.driverOrderDetails.paymentStatus == "Pending"
                          ? Colors.orange
                          : Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${orderDetails.driverOrderDetails.deliveryDay}, ${orderDetails.driverOrderDetails.deliveryDate} at ${orderDetails.driverOrderDetails.deliveryTime}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShopInfo(OrderDetailsModel orderDetails) {
    return Card(
      color: AppColors.background,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Shop Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              orderDetails.driverOrderDetails.shopName,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              orderDetails.driverOrderDetails.address,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems(OrderDetailsModel orderDetails) {
    return Card(
      color: AppColors.background,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Items',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orderDetails.driverOrderDetails.items.length,
              itemBuilder: (context, index) {
                final item = orderDetails.driverOrderDetails.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          item.productImage,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.image, size: 60),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.productName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${orderDetails.driverOrderDetails.amount} ${orderDetails.driverOrderDetails.currency}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo(OrderDetailsModel orderDetails) {
    return Card(
      color: AppColors.background,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              orderDetails.driverOrderDetails.customerName,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 8),
                Text(
                  orderDetails.driverOrderDetails.customerPhone,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo(OrderDetailsModel orderDetails) {
    return Card(
      color: AppColors.background,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Method:'),
                Text(
                  orderDetails.driverOrderDetails.paymentMethod,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Payment Status:'),
                Chip(
                  label: Text(
                    orderDetails.driverOrderDetails.paymentStatus,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor:
                      orderDetails.driverOrderDetails.paymentStatus == "Pending"
                          ? Colors.orange
                          : Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
