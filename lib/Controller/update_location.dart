import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Core/Constants/api.dart';

class UpdateLoController extends ChangeNotifier {
  Timer? _timer;

  UpdateLoController() {
    if (kDebugMode) {
      print("🚀 UpdateLocationController Initialized!");
    }
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      if (kDebugMode) {
        print("🔄 Checking for location updates...");
      }

      try {
        Position position = await Geolocator.getCurrentPosition(
          // ignore: deprecated_member_use
          desiredAccuracy: LocationAccuracy.best,
          // ignore: deprecated_member_use
          forceAndroidLocationManager: true,
        );

        if (kDebugMode) {
          print(
            "📍 Location Updated: Latitude ${position.latitude}, Longitude ${position.longitude}",
          );
        }

        // ✅ Send location to API
        await updateLocationAPI(position.latitude, position.longitude);
      } catch (e) {
        if (kDebugMode) {
          print("❌ Error fetching location: $e");
        }
      }
    });
  }

  Future<void> updateLocationAPI(double latitude, double longitude) async {
    if (kDebugMode) {
      print("🌐 Sending location update to API...");
    }
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.updatelocation),
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "Bearer 519|zxjFL6j9q7GVC0zE6XnS8oe4c8RCOa2nvC0Vgc6S96e50767 ",
        },
        body: jsonEncode({
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
        }),
      );

      if (kDebugMode) {
        print("📜 API Response Status: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("📜 Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print(" Location updated successfully!");
        }
      } else {
        if (kDebugMode) {
          print("❌ Backend rejected update: ${response.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("❌ Error sending location: $e");
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
