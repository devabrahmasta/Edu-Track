import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService(this._preferences);

  static const isLoggedInKey = 'is_logged_in';
  static const userDataKey = 'user_data';

  final SharedPreferences _preferences;

  bool? getBool(String key) => _preferences.getBool(key);

  String? getString(String key) => _preferences.getString(key);

  List<String>? getStringList(String key) => _preferences.getStringList(key);

  Future<bool> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  Future<bool> setString(String key, String value) =>
      _preferences.setString(key, value);

  Future<bool> setStringList(String key, List<String> value) =>
      _preferences.setStringList(key, value);

  Future<bool> remove(String key) => _preferences.remove(key);

  Future<void> clearSession() async {
    await remove(isLoggedInKey);
    await remove(userDataKey);
  }
}
