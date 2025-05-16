class CompletedOrdersModel {
  final bool success;
  final String message;
  final int status;
  final CompletedOrdersData data;

  CompletedOrdersModel({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory CompletedOrdersModel.fromJson(Map<String, dynamic> json) {
    return CompletedOrdersModel(
      success: json['success'],
      message: json['message'],
      status: json['status'],
      data: CompletedOrdersData.fromJson(json['data']),
    );
  }
}

class CompletedOrdersData {
  final int orderCount;
  final List<CompletedOrder> driverOrders;

  CompletedOrdersData({required this.orderCount, required this.driverOrders});

  factory CompletedOrdersData.fromJson(Map<String, dynamic> json) {
    return CompletedOrdersData(
      orderCount: json['order_count'],
      driverOrders: List<CompletedOrder>.from(
        json['driver_orders'].map((x) => CompletedOrder.fromJson(x)),
      ),
    );
  }
}

class CompletedOrder {
  final int orderId;
  final String orderNo;
  final String customerName;
  final String orderAddress;

  CompletedOrder({
    required this.orderId,
    required this.orderNo,
    required this.customerName,
    required this.orderAddress,
  });

  factory CompletedOrder.fromJson(Map<String, dynamic> json) {
    return CompletedOrder(
      orderId: json['order_id'],
      orderNo: json['order_no'],
      customerName: json['customer_name'],
      orderAddress: json['order_address'],
    );
  }
}
