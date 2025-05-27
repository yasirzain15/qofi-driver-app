import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qufi_driver_app/Controller/order_completion_controller.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Consumer<OrderCompletionController>(
        builder: (context, controller, _) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed:
                controller.isLoading
                    ? null
                    : () => _completeOrder(context, controller),
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
          );
        },
      ),
    );
  }

  Future<void> _completeOrder(
    BuildContext context,
    OrderCompletionController controller,
  ) async {
    final success = await controller.completeOrder(
      token: token,
      orderId: orderId,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Order completed successfully!' : controller.errorMessage,
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );

      if (success) {
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) Navigator.of(context).pop();
      }
    }
  }
}
