class OrderModel {
  final String orderId;
  final String customer;
  final String address;
  late final String status;

  OrderModel({
    required this.orderId,
    required this.customer,
    required this.address,
    required this.status,
  });
}
