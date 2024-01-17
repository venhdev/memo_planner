import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String _keyLoggedIn = 'logged_in';
  static final String _keyLastLoginTime = 'last_login_time';


  static Future<SharedPreferences> get _instance async =>
      await SharedPreferences.getInstance();

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await _instance;
    return prefs.getBool(_keyLoggedIn) ?? false;
  }

  static Future<void> setLoggedIn(bool loggedIn) async {
    final SharedPreferences prefs = await _instance;
    prefs.setBool(_keyLoggedIn, loggedIn);
  }

  static Future<DateTime?> getLastLoginTime() async {
    final SharedPreferences prefs = await _instance;
    final int? timestamp = prefs.getInt(_keyLastLoginTime);
    return timestamp != null ? DateTime.fromMillisecondsSinceEpoch(timestamp) : null;
  }

  static Future<void> setLastLoginTime(DateTime loginTime) async {
    final SharedPreferences prefs = await _instance;
    prefs.setInt(_keyLastLoginTime, loginTime.millisecondsSinceEpoch);
  }

  static Future<void> clearLoginData() async {
    final SharedPreferences prefs = await _instance;
    prefs.remove(_keyLoggedIn);
    prefs.remove(_keyLastLoginTime);
  }
}


abstract class SharedPreferencesUtil {
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
}

class SharedPreferencesUtilImpl implements SharedPreferencesUtil {
  static const String _kTokenKey = 'token';

  @override
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kTokenKey);
  }

  //delele token
  @override
  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTokenKey);
  }
}
