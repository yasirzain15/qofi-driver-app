class AuthResponse {
  final bool isSuccessful;
  final String message;

  AuthResponse({required this.isSuccessful, required this.message});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      isSuccessful: json['success'],
      message: json['message'],
    );
  }
}
