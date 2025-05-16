import 'package:flutter/material.dart';
import 'package:qufi_driver_app/Model/completed_orders_model.dart';
import 'package:qufi_driver_app/Services/orders_services.dart';

class CompletedOrdersController extends ChangeNotifier {
  List<CompletedOrder> completedOrders = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchCompletedOrders(String token) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final response = await OrderService.getCompletedOrders();
      completedOrders = response.data.driverOrders;
    } catch (e) {
      error = 'Failed to load completed orders';
    }

    isLoading = false;
    notifyListeners();
  }
}
