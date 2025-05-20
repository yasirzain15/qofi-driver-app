import 'package:flutter/material.dart';

class OrderRequestCard extends StatelessWidget {
  final String orderNumber;
  final String customerName;
  final String address;
  final String amount;
  final String paymentMethod;

  const OrderRequestCard({
    super.key,
    required this.orderNumber,
    required this.customerName,
    required this.address,
    required this.amount,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Request',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Order #$orderNumber'),
            const SizedBox(height: 8),
            Text(customerName),
            const SizedBox(height: 8),
            Text(address),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Amount: $amount'),
                Text('Payment: $paymentMethod'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle accept action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Accept'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle reject action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage:
// OrderRequestCard(
//   orderNumber: '1234',
//   customerName: 'James Smith',
//   address: '123 Main St',
//   amount: '\$25.00',
//   paymentMethod: 'COD',
// )
