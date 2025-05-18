import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Core/Constants/api.dart';
import 'package:qufi_driver_app/Model/completed_orders_model.dart';

class OrderService {
  static Future<CompletedOrdersModel> getCompletedOrders() async {
    final response = await http.get(
      Uri.parse(ApiConstants.completedOrders),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 313|yaMg3fmxrPFzwigBQbcHaSFORAVj351Ehc2QXQia4e2ef0bf',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return CompletedOrdersModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch completed orders');
    }
    print("Response Body: ${response.body}");
  }
}
