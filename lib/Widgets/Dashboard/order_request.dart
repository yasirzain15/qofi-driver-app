// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

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

  Future<void> sendOrderResponse(BuildContext context, String action) async {
    try {
      print(
        "🔹 Sending request: orderId=${widget.order_Id}, action=$action",
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

      print("🔹 Response Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Order $action successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final Map<String, dynamic>? errorData = jsonDecode(response.body);
        String errorMessage =
            errorData?['message'] ?? "❌ Failed to $action order";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print("❌ Error Sending Response: $e"); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error: $e"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
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
          Text("🔹 Order ID: ${widget.order_Id}"),
          Text("🔹 Customer: James Smith"),
          Text("🔹 Address: 123 Main St"),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            sendOrderResponse(context, "accept");
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Accept", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: () {
            sendOrderResponse(context, "reject");
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context);
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 216, 215, 215),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Reject", style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}
