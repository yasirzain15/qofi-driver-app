import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/order_completion_controller.dart';
import 'package:qufi_driver_app/Controller/order_details_controller.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/customer_info.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/mark_complete_button.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/order_header.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/order_items.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/payment_info.dart';
import 'package:qufi_driver_app/Widgets/Dashboard/Ongoing%20Orders%20Details/shof_info.dart';

class OrderDetailsView extends StatefulWidget {
  final int orderId;
  final String token;

  const OrderDetailsView({
    super.key,
    required this.orderId,
    required this.token,
  });

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderDetailsController>(
        context,
        listen: false,
      ).fetchOrderDetails(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderCompletionController()),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Order Details #${widget.orderId}'),
          centerTitle: true,
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer2<OrderDetailsController, OrderCompletionController>(
      builder: (context, detailsController, completionController, _) {
        if (detailsController.isLoading &&
            detailsController.orderDetails == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (detailsController.errorMessage != null) {
          return Center(
            child: Text(
              detailsController.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (detailsController.orderDetails == null) {
          return const Center(child: Text('No order details available'));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderHeader(
                      orderDetails:
                          detailsController.orderDetails!.driverOrderDetails,
                    ),
                    const SizedBox(height: 20),
                    ShopInfo(
                      orderDetails:
                          detailsController.orderDetails!.driverOrderDetails,
                    ),
                    const SizedBox(height: 20),
                    OrderItems(
                      orderDetails:
                          detailsController.orderDetails!.driverOrderDetails,
                    ),
                    const SizedBox(height: 20),
                    CustomerInfo(
                      orderDetails:
                          detailsController.orderDetails!.driverOrderDetails,
                    ),
                    const SizedBox(height: 20),
                    PaymentInfo(
                      orderDetails:
                          detailsController.orderDetails!.driverOrderDetails,
                    ),
                  ],
                ),
              ),
            ),
            MarkCompleteButton(orderId: widget.orderId, token: widget.token),
          ],
        );
      },
    );
  }
}
