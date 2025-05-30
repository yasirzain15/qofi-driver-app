import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/order_completion_controller.dart';
import 'package:qufi_driver_app/Controller/ongoing_orders_controller.dart';

class MarkCompleteButton extends StatelessWidget {
  final int orderId;
  final String token;

  const MarkCompleteButton({
    super.key,
    required this.orderId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderCompletionController>(
      builder: (context, controller, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed:
                controller.isLoading ? null : () => _completeOrder(context),
            child:
                controller.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                      'MARK AS COMPLETE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
          ),
        );
      },
    );
  }

  Future<void> _completeOrder(BuildContext context) async {
    final completionController = Provider.of<OrderCompletionController>(
      context,
      listen: false,
    );
    final ongoingController = Provider.of<OngoingOrdersController>(
      context,
      listen: false,
    );

    final success = await completionController.completeOrder(
      token: token,
      orderId: orderId,
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Order completed successfully!'
              : completionController.errorMessage,
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );

    if (success) {
      // Refresh ongoing orders before navigating back
      await ongoingController.fetchOngoingOrders(token);

      if (context.mounted) {
        Navigator.of(context).pop(true); // Pass result to trigger refresh
      }
    }
  }
}
