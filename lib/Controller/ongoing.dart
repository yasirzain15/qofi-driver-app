import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveOngoingOrderStatus(bool hasOrder) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasOngoingOrder', hasOrder); // ✅ Save status globally
}

Future<bool> getOngoingOrderStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('hasOngoingOrder') ?? false; // ✅ Get status globally
}

Future<void> checkOngoingOrders() async {
  bool hasOngoingOrders = await getOngoingOrderStatus();

  if (hasOngoingOrders) {
    print("🚀 Driver has ongoing orders! Start location tracking.");
  } else {
    print("❌ No ongoing orders. Stop location tracking.");
  }
}
