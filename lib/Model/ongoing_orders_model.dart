class OngoingOrders {
  final bool success;
  final String message;
  final int status;
  final OngoingData data;

  OngoingOrders({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory OngoingOrders.fromJson(Map<String, dynamic> json) {
    return OngoingOrders(
      success: json['success'],
      message: json['message'],
      status: json['status'],
      data: OngoingData.fromJson(json['data']),
    );
  }
}

class OngoingData {
  final int orderCount;
  final List<DriverOrder> driverOrders;

  OngoingData({required this.orderCount, required this.driverOrders});

  factory OngoingData.fromJson(Map<String, dynamic> json) {
    return OngoingData(
      orderCount: json['order_count'],
      driverOrders:
          (json['driver_orders'] as List)
              .map((e) => DriverOrder.fromJson(e))
              .toList(),
    );
  }
}

class DriverOrder {
  final int orderId;
  final String orderNo;
  final String customerName;
  final String orderAddress;

  DriverOrder({
    required this.orderId,
    required this.orderNo,
    required this.customerName,
    required this.orderAddress,
  });

  factory DriverOrder.fromJson(Map<String, dynamic> json) {
    return DriverOrder(
      orderId: json['order_id'],
      orderNo: json['order_no'],
      customerName: json['customer_name'],
      orderAddress: json['order_address'],
    );
  }
}
