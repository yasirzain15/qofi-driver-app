class CompleteOrderResponse {
  final bool success;
  final String message;
  final int status;
  final List<dynamic> data;

  CompleteOrderResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory CompleteOrderResponse.fromJson(Map<String, dynamic> json) {
    return CompleteOrderResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: json['data'] ?? [],
    );
  }
}
