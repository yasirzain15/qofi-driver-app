import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Core/Constants/api.dart';

class MarkCompletionController with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isCompleted = false;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isCompleted => _isCompleted;

  Future<bool> completeOrder({
    required String token,
    required int orderId,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    _isCompleted = false;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(ApiConstants.completeOrder),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'order_id': orderId}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _isCompleted = responseData['success'] ?? false;
        _errorMessage =
            responseData['message'] ?? 'Order completed successfully';
        return true;
      } else {
        _errorMessage = responseData['message'] ?? 'Failed to complete order';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _errorMessage = '';
    _isCompleted = false;
    notifyListeners();
  }
}
