import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static late SharedPreferences sharedPreferences;

  static const String _tokenKey = 'token';
  static const String _onBoardingKey = 'hasSeenOnBoarding';
  static const String _deviceIdKey = 'linked_device_id';
  static const String _userIdKey = 'user_id';
  static const String kCachedEmail = 'cached_email';
  static const String kCachedPassword = 'cached_password';

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  static String? get token => sharedPreferences.getString(_tokenKey);

  static Future<void> saveDeviceId(String id) async {
    await sharedPreferences.setString(_deviceIdKey, id);
  }

  static String? get getDeviceId => sharedPreferences.getString(_deviceIdKey);

  static Future<void> setHasSeenOnBoarding(bool value) async {
    await sharedPreferences.setBool(_onBoardingKey, value);
  }

  static bool getHasSeenOnBoarding() {
    return sharedPreferences.getBool(_onBoardingKey) ?? false;
  }

  static Future<void> saveCustomDeviceName(String deviceId, String name) async {
    await sharedPreferences.setString('device_name_$deviceId', name);
  }

  static String? getCustomDeviceName(String deviceId) {
    return sharedPreferences.getString('device_name_$deviceId');
  }

  static Future<void> saveUserId(String id) async {
    await sharedPreferences.setString(_userIdKey, id);
  }

  static String? get getUserId => sharedPreferences.getString(_userIdKey);

  static Future<void> clearToken() async {
    await sharedPreferences.remove(_tokenKey);
    await sharedPreferences.remove(_userIdKey);
    print("🧹 Local Data Cleared");
  }

  static Future<void> saveUserCredentials(String email, String password) async {
    await sharedPreferences.setString(kCachedEmail, email);
    await sharedPreferences.setString(kCachedPassword, password);
  }

  static String? getCachedEmail() {
    return sharedPreferences.getString(kCachedEmail);
  }

  static String? getCachedPassword() {
    return sharedPreferences.getString(kCachedPassword);
  }

  static Future<void> clearUserCredentials() async {
    await sharedPreferences.remove(kCachedEmail);

    await sharedPreferences.remove(kCachedPassword);
  }

  static Future<void> saveLastSyncTime() async {
    await sharedPreferences.setString(
      'last_sync_time',
      DateTime.now().toIso8601String(),
    );
  }

  static String? getLastSyncTime() {
    return sharedPreferences.getString('last_sync_time');
  }
}
