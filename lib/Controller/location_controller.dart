// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationController extends ChangeNotifier {
  // Request location permissions if not granted

  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return false;
    } else if (permission == LocationPermission.deniedForever) {
      if (kDebugMode) {
        print(
          " Location permission permanently denied. Redirecting to settings.",
        );
      }
      return false;
    }

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    return (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) &&
        isLocationEnabled;
  }

  //  Fetch the user's current latitude & longitude
  Future<Position?> getCurrentLocation() async {
    bool hasPermission = await checkLocationPermission();
    if (!hasPermission) {
      if (kDebugMode) {
        print(" Location permission denied.");
      }
      return null;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high, // Set desired accuracy
        ),
      );

      if (kDebugMode) {
        print(
          " Current Location: Latitude ${position.latitude}, Longitude ${position.longitude}",
        );
      }

      return position;
    } catch (e) {
      if (kDebugMode) {
        print(" Error fetching location: $e");
      }
      return null;
    }
  }

  Future<void> checkLocationServices() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      if (kDebugMode) {
        print(" Location services are OFF");
      }
    }

    if (permission == LocationPermission.denied) {
      if (kDebugMode) {
        print(" Location permissions are DENIED");
      }
    }
  }

  void fetchUserLocation(BuildContext context) async {
    bool hasPermission = await checkLocationPermission();
    if (!hasPermission) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Enable Location"),
              content: Text("Please enable location to proceed."),
              actions: [
                TextButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                    Navigator.pop(context);
                  },
                  child: Text("Go to Settings"),
                ),
              ],
            ),
      );
      return;
    }

    Position? position = await getCurrentLocation();
    if (position != null) {
      if (kDebugMode) {
        print(
          " Latitude: ${position.latitude}, Longitude: ${position.longitude}",
        );
      }
    } else {
      if (kDebugMode) {
        print(" Unable to fetch location.");
      }
    }
  }

  // void fetchUserLocation() async {
  //   Position? position = await LocationController().getCurrentLocation();
  //   if (position != null) {
  //     if (kDebugMode) {
  //       print(
  //         "✅ Latitude: ${position.latitude}, Longitude: ${position.longitude}",
  //       );
  //     }
  //   } else {
  //     if (kDebugMode) {
  //       print(" Unable to fetch location.");
  //     }
  //   }
  // }
}
