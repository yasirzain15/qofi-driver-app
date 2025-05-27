import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:qufi_driver_app/Core/Constants/api.dart';

class UpdateLoController extends ChangeNotifier {
  Timer? _timer;

  UpdateLoController() {
    print("🚀 UpdateLocationController Initialized!");
    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
      print("🔄 Checking for location updates...");

      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true,
        );

        print(
          "📍 Location Updated: Latitude ${position.latitude}, Longitude ${position.longitude}",
        );

        // ✅ Send location to API
        await updateLocationAPI(position.latitude, position.longitude);
      } catch (e) {
        print("❌ Error fetching location: $e");
      }
    });
  }

  Future<void> updateLocationAPI(double latitude, double longitude) async {
    print("🌐 Sending location update to API...");
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

      print("📜 API Response Status: ${response.statusCode}");
      print("📜 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        print("✅ Location updated successfully!");
      } else {
        print("❌ Backend rejected update: ${response.body}");
      }
    } catch (e) {
      print("❌ Error sending location: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
