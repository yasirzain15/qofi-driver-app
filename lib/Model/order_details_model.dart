class OrderDetailsModel {
  final bool success;
  final String message;
  final int status;
  final DriverOrderDetails driverOrderDetails;

  OrderDetailsModel({
    required this.success,
    required this.message,
    required this.status,
    required this.driverOrderDetails,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      success: json['success'],
      message: json['message'],
      status: json['status'],
      driverOrderDetails: DriverOrderDetails.fromJson(
        json['data']['driver_order_details'],
      ),
    );
  }
}

class DriverOrderDetails {
  final int orderId;
  final String currency;
  final String orderNo;
  final String shopId;
  final String shopName;
  final String address;
  final String amount;
  final String deliveryDay;
  final String deliveryTime;
  final String deliveryDate;
  final List<OrderItem> items;
  final String customerName;
  final String customerPhone;
  final String paymentMethod;
  final String paymentStatus;

  DriverOrderDetails({
    required this.orderId,
    required this.currency,
    required this.orderNo,
    required this.shopId,
    required this.shopName,
    required this.address,
    required this.amount,
    required this.deliveryDay,
    required this.deliveryTime,
    required this.deliveryDate,
    required this.items,
    required this.customerName,
    required this.customerPhone,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  factory DriverOrderDetails.fromJson(Map<String, dynamic> json) {
    return DriverOrderDetails(
      orderId: json['order_id'],
      currency: json['currency'],
      orderNo: json['order_no'],
      shopId: json['shop_id'],
      shopName: json['shop_name'],
      address: json['address'],
      amount: json['amount'],
      deliveryDay: json['delivery_day'],
      deliveryTime: json['delivery_time'],
      deliveryDate: json['delivery_date'],
      items: (json['items'] as List).map((e) => OrderItem.fromJson(e)).toList(),
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'],
    );
  }
}

class OrderItem {
  final String productName;
  final String productImage;

  OrderItem({required this.productName, required this.productImage});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['product_name'],
      productImage: json['product_image'],
    );
  }
}
