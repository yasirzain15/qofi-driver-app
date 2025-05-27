// import 'dart:convert';

// import 'package:http/http.dart' as http;

// void sendLocationToAPI(double lat, double lon) async {
//   final response = await http.post(
//     Uri.parse("https://staging.riseupkw.net/qofi/api/v1/driver/update/latlng"),
//     body: jsonEncode({"latitude": lat, "longitude": lon}),
//     headers: {"Content-Type": "application/json"},
//   );

//   if (response.statusCode == 200) {
//     print("Driver location updated successfully");
//   } else {
//     print("Failed to update location");
//   }
// }
