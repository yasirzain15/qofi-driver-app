import 'package:shared_preferences/shared_preferences.dart';

class NameController {
  /// ✅ Save the name locally
  Future<void> saveDriverName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('driverName', name);
    print("✅ Saved Name Locally: $name");
  }

  /// ✅ Retrieve the saved name
  Future<String?> getDriverName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('driverName');

    print("🔍 Retrieved Name from Local Storage: $name");
    return name;
  }
}
