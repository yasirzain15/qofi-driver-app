import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Core/Constants/api.dart';
import 'package:qufi_driver_app/Model/order_completion_model.dart';

class OrderCompletionController with ChangeNotifier {
  bool _isLoading = false;
  String _errorMessage = '';
  OrderCompletionResponse? _completionResponse;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  OrderCompletionResponse? get completionResponse => _completionResponse;

  Future<bool> completeOrder({
    required String token,
    required int orderId,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final url = Uri.parse(ApiConstants.completeOrder);
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      };
      final body = json.encode({'order_id': orderId});

      debugPrint('Completing order $orderId');
      debugPrint('Request to: ${url.toString()}');
      debugPrint('Headers: $headers');
      debugPrint('Body: $body');

      final response = await http
          .post(url, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));

      debugPrint('Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _completionResponse = OrderCompletionResponse.fromJson(jsonResponse);

        if (_completionResponse!.success) {
          debugPrint('Order $orderId completed successfully');
          return true;
        } else {
          _errorMessage = _completionResponse!.message;
          return false;
        }
      } else {
        _errorMessage = _parseError(response);
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _parseError(http.Response response) {
    try {
      final errorBody = json.decode(response.body);
      return errorBody['message'] ??
          errorBody['error'] ??
          'Failed to complete order (${response.statusCode})';
    } catch (e) {
      return 'Failed to parse error response (${response.statusCode})';
    }
  }

  void reset() {
    _isLoading = false;
    _errorMessage = '';
    _completionResponse = null;
    notifyListeners();
  }
}
