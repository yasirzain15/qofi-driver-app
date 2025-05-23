import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Core/Constants/api.dart';
import 'package:qufi_driver_app/Model/order_details_model.dart';

class OrderDetailsController with ChangeNotifier {
  OrderDetailsModel? orderDetails;
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchOrderDetails() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final url = Uri.parse(ApiConstants.ongoingOrderDetails);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 466|s4NGNVmj5Bnp930xUV1WMqjnunwRjdNsmWYtEaYUdec21b50',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        orderDetails = OrderDetailsModel.fromJson(jsonData);
      } else {
        errorMessage = 'Failed to load order details';
      }
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
