class ApiConstants {
  static const String baseUrl = "https://staging.riseupkw.net/qofi/api/v1";

  // Endpoints
  static const String login = "$baseUrl/driver/login";
  static const String driverProfile = "$baseUrl/driver/profile";
  static const String ongoingOrders = "$baseUrl/driver/getOrders/ongoing";
  static const String completedOrders = "$baseUrl/driver/getOrders/completed";
  static const String ongoingOrderDetails = "$baseUrl/driver/order/77/details";
  static const String updatelocation = "$baseUrl/driver/update/latlng";
  static const String completeOrder = "$baseUrl/driver/order/complete";
}
