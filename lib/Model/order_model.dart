import 'package:qufi_driver_app/Model/completed_orders_model.dart';
import 'package:qufi_driver_app/Model/ongoing_orders_model.dart';

class OrderModel {
  final String orderNo;
  final String status; // "Ongoing" or "Completed"
  final bool picked;

  OrderModel({
    required this.orderNo,
    required this.status,
    required this.picked,
  });

  // Converters from other models
  factory OrderModel.fromDriverOrder(
    DriverOrder order,
    String status, {
    bool picked = false,
  }) {
    return OrderModel(orderNo: order.orderNo, status: status, picked: picked);
  }

  factory OrderModel.fromCompletedOrder(
    CompletedOrder order,
    String status, {
    bool picked = false,
  }) {
    return OrderModel(orderNo: order.orderNo, status: status, picked: picked);
  }
}
