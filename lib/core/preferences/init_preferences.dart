import 'package:shared_preferences/shared_preferences.dart';

class InitializationPreferences {
  static const INIT_KEY = "init_key";

  Future<void> initialize() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(INIT_KEY, true);
  }

  Future<bool> isInitialized() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(INIT_KEY) ?? false;
  }
}
