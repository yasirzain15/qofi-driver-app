class OrderRequestModel {
  final String orderNumber;
  final String customerName;
  final String address;
  final double amount;
  final String paymentMethod;

  OrderRequestModel({
    required this.orderNumber,
    required this.customerName,
    required this.address,
    required this.amount,
    required this.paymentMethod,
  });

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) {
    return OrderRequestModel(
      orderNumber: json['orderNumber'],
      customerName: json['customerName'],
      address: json['address'],
      amount: json['amount'].toDouble(),
      paymentMethod: json['paymentMethod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderNumber': orderNumber,
      'customerName': customerName,
      'address': address,
      'amount': amount,
      'paymentMethod': paymentMethod,
    };
  }
}
