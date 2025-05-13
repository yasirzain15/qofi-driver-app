import 'package:qufi_driver_app/Model/drivermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class SharedPrefsService {
  static Future<void> saveDriverData(Driver driver) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'driver_data',
      jsonEncode({
        'id': driver.id,
        'username': driver.username,
        'email': driver.email,
        'phone': driver.phone,
        'image': driver.image,
        'token': driver.token,
      }),
    );
  }

  static Future<Driver?> getDriverData() async {
    final prefs = await SharedPreferences.getInstance();
    String? driverJson = prefs.getString('driver_data');

    if (driverJson != null) {
      Map<String, dynamic> driverMap = jsonDecode(driverJson);
      return Driver.fromJson(driverMap);
    }
    return null;
  }

  static Future<void> removeDriverData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('driver_data');
  }
}
