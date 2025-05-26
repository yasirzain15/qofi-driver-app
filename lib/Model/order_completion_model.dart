class OrderCompletionResponse {
  final bool success;
  final String message;
  final int status;
  final List<dynamic> data;

  OrderCompletionResponse({
    required this.success,
    required this.message,
    required this.status,
    required this.data,
  });

  factory OrderCompletionResponse.fromJson(Map<String, dynamic> json) {
    return OrderCompletionResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      status: json['status'] ?? 0,
      data: json['data'] ?? [],
    );
  }

  @override
  String toString() {
    return 'OrderCompletionResponse(success: $success, message: $message, status: $status)';
  }
}
