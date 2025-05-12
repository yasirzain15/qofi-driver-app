import 'package:flutter/material.dart';
import 'package:qufi_driver_app/View/order_request_card.dart';
import '../../../core/constants/app_colors.dart';

class OngoingOrderCard extends StatelessWidget {
  const OngoingOrderCard({super.key});
  void _showOrderRequest(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0), // top spacing
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: const OrderRequestCard(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        title: const Text(
          'Order #1234',
          style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('James Smith', style: TextStyle(color: AppColors.subText)),
            Text('00B Main St', style: TextStyle(color: AppColors.subText)),
          ],
        ),
        trailing: GestureDetector(
          onTap: () => _showOrderRequest(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.pickedTag,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text('Picked', style: TextStyle(fontSize: 12)),
          ),
        ),
      ),
    );
  }
}
