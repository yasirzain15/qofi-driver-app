import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qufi_driver_app/Core/Constants/app_colors.dart';
import 'package:qufi_driver_app/Model/order_details_model.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerInfo extends StatelessWidget {
  final DriverOrderDetails orderDetails;

  const CustomerInfo({super.key, required this.orderDetails});

  Future<void> _launchPhoneDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
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
              orderDetails.customerName,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _launchPhoneDialer(orderDetails.customerPhone),
                  child: Text(
                    orderDetails.customerPhone,
                    style: TextStyle(
                      color: Colors.blue, // Make it look clickable
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.content_copy, size: 16),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: orderDetails.customerPhone),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phone number copied')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
