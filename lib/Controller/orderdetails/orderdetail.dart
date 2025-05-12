import 'package:qufi_driver_app/Model/orderdeatils/orderdetailsmodel.dart';

class OrderController {
  // Private order lists
  final List<OrderModel> _completedOrders = [];
  final List<OrderModel> _ongoingOrders = [];
  final List<OrderModel> _orders = [];

  // Getter for tab names
  List<String> get tabNames => ["Orders", "Completed", "Ongoing "];

  // Getters for order lists
  List<OrderModel> getCompletedOrders() => List.unmodifiable(_completedOrders);
  List<OrderModel> getOngoingOrders() => List.unmodifiable(_ongoingOrders);
  List<OrderModel> getOrders() => List.unmodifiable(_orders);

  // Dynamic count getters
  int get completedCount => _completedOrders.length;
  int get ongoingCount => _ongoingOrders.length;
  int get totalOrders => _orders.length;

  // 🔹 Add a new order dynamically
  void addOrder(
    OrderModel order, {
    bool isCompleted = false,
    bool isOngoing = false,
  }) {
    _orders.add(order);
    if (isCompleted) _completedOrders.add(order);
    if (isOngoing) _ongoingOrders.add(order);
  }

  // 🔹 Update an order status
  void updateOrderStatus(String orderId, String newStatus) {
    for (var order in _orders) {
      if (order.orderId == orderId) {
        order.status = newStatus;
        return;
      }
    }
  }

  // 🔹 Remove an order by ID
  void removeOrder(String orderId) {
    _orders.removeWhere((order) => order.orderId == orderId);
    _completedOrders.removeWhere((order) => order.orderId == orderId);
    _ongoingOrders.removeWhere((order) => order.orderId == orderId);
  }

  // 🔹 Load initial orders
  void initializeOrders() {
    _orders.addAll([
      OrderModel(
        orderId: "Order # 1234",
        customer: "James Smith",
        address: "COD Main St",
        status: "Picked",
      ),
      OrderModel(
        orderId: "Order # 1210",
        customer: "Alex Carter",
        address: "789 Pine St",
        status: "Delivered",
      ),
    ]);

    _ongoingOrders.add(_orders[0]);
    _completedOrders.add(_orders[1]);
  }
}
