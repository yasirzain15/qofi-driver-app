// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationRequiredScreen extends StatelessWidget {
  const LocationRequiredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: AlertDialog(
            title: Text("Enable Location"),
            content: Text("Please enable location to proceed."),
            actions: [
              TextButton(
                onPressed: () async {
                  await Geolocator.openLocationSettings();
                  // Navigator.pop(context);
                },
                child: Text("Go to Settings"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
