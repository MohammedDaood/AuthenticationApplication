import 'package:shared_preferences/shared_preferences.dart';

class PrefUtils {
  static SharedPreferences? _prefs;
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyUsername = 'username';
  static const String _keyDeviceId = 'device_id';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool isOnboardingCompleted() {
    return _prefs?.getBool(_keyOnboardingCompleted) ?? false;
  }

  static Future<void> setOnboardingCompleted() async {
    await _prefs?.setBool(_keyOnboardingCompleted, true);
  }

  static Future<void> saveDeviceId(String DeviceId) async {
    await _prefs?.setString(_keyDeviceId, DeviceId);
  }

  static String getDeviceId() {
    return _prefs?.getString(_keyDeviceId) ?? '';
  }

  static Future<void> saveUsername(String username) async {
    await _prefs?.setString(_keyUsername, username);
  }

  static String getUsername() {
    return _prefs?.getString(_keyUsername) ?? '';
  }
}
