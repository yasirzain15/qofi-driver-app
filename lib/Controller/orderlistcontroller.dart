import 'package:qufi_driver_app/model/orderlistmodel.dart';

class OrderController {
  List<OrderModel> ongoingOrders = [
    OrderModel(
      orderId: "1234",
      customer: "James Smith",
      address: "COD Main St",
      status: "Picked",
    ),
    OrderModel(
      orderId: "1232",
      customer: "Meilly Johnson",
      address: "456 Elm St",
      status: "Dispatched",
    ),
  ];

  List<OrderModel> completedOrders = [
    OrderModel(
      orderId: "1210",
      customer: "Alex Carter",
      address: "789 Pine St",
      status: "Delivered",
    ),
  ];
}
