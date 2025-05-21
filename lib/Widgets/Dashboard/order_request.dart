import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qufi_driver_app/Core/Constants/app_colors.dart';

class OrderResponseScreen extends StatefulWidget {
  final String order_Id;

  const OrderResponseScreen({super.key, required this.order_Id});

  @override
  _OrderResponseScreenState createState() => _OrderResponseScreenState();
}

class _OrderResponseScreenState extends State<OrderResponseScreen> {
  final String baseUrl =
      'https://staging.riseupkw.net/qofi/api/v1/driver/requestResponse';

  Future<void> sendOrderResponse(String action) async {
    try {
      print(
        "Sending request: orderId=${widget.order_Id}, action=$action",
      ); // Debugging

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 410|JskcCBBUHBT1yAaV4a3Msf7IQrWqel4FCQVuxoFm33c05123',
        },
        body: json.encode({"order_id": widget.order_Id, "action": action}),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      bool success = response.statusCode == 200;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? "Order $action successfully!" : "Failed to $action order",
          ),
        ),
      );
    } catch (e) {
      print("Error: $e"); // Debugging
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Center(child: Text("Order Request")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Order Request"),
          Text("Order1234"),
          Text("James smith"),
          Text("123 Main St"),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => sendOrderResponse("accept"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          child: Text(
            "Accept",
            style: TextStyle(color: const Color.fromARGB(255, 216, 214, 214)),
          ),
        ),
        ElevatedButton(
          onPressed: () => sendOrderResponse("reject"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 216, 215, 215),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text("Reject", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
