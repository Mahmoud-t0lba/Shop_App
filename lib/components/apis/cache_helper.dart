import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> putBoolean({
    required String key,
    required bool value,
  }) async {
    return await sharedPreferences!.setBool(key, value);
  }

  static dynamic getData({
    String? key,
  }) {
    return sharedPreferences!.get(key!);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await sharedPreferences!.setString(key, value);
    if (value is int) return await sharedPreferences!.setInt(key, value);
    if (value is bool) return await sharedPreferences!.setBool(key, value);

    return await sharedPreferences!.setDouble(key, value);
  }

  static Future<bool> removeData({
    String? key,
  }) async {
    return await sharedPreferences!.remove(key!);
  }
}

class SecureStorageUtil {
  static const FlutterSecureStorage _preferences = FlutterSecureStorage();

  static Future<String?> getString(String key, {String defValue = ''}) {
    return _preferences.read(key: key);
  }

  static Future<void> putString(String key, String value) {
    return _preferences.write(key: key, value: value);
  }

  static Future<void> delString(String key) {
    return _preferences.delete(key: key);
  }
}
