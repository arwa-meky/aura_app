import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences sharedPreferences;

  static const String _tokenKey = 'token';
  static const String _onBoardingKey = 'hasSeenOnBoarding';

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  static String? get token => sharedPreferences.getString(_tokenKey);

  static Future<void> clearToken() async {
    await sharedPreferences.remove(_tokenKey);
  }

  static Future<void> setHasSeenOnBoarding(bool value) async {
    await sharedPreferences.setBool(_onBoardingKey, value);
  }

  static bool getHasSeenOnBoarding() {
    return sharedPreferences.getBool(_onBoardingKey) ?? false;
  }
}
