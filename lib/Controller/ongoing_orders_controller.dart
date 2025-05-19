import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Core/Constants/api.dart';
import 'package:qufi_driver_app/Model/ongoing_orders_model.dart';

class OngoingOrdersController with ChangeNotifier {
  OngoingOrders? _ongoingOrders;
  bool _isLoading = false;
  String _error = '';

  OngoingOrders? get ongoingOrders => _ongoingOrders;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchOngoingOrders(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      log("API Token : ${token}");
      final response = await http.get(
        Uri.parse(ApiConstants.ongoingOrders),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 313|yaMg3fmxrPFzwigBQbcHaSFORAVj351Ehc2QXQia4e2ef0bf',
        },
      );
      log("Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _ongoingOrders = OngoingOrders.fromJson(data);
        log(_ongoingOrders.toString());
        _error = '';
      } else {
        _error = 'Failed:${response.statusCode}';
        _ongoingOrders = null;
      }
    } catch (e) {
      _error = 'Error: $e';
      _ongoingOrders = null;
    }

    _isLoading = false;
    notifyListeners();
  }
}
