import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;
  static const _userToken = 'token';
  static const _userId = 'userid';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserToken(String token) async {
    await _preferences!.setString(_userToken, token);
  }

  String get getUserToken {
    return _preferences!.getString(_userToken)!;
  }

  static Future setUserId(String uId) async {
    await _preferences!.setString(_userId, uId);
  }

  String get getUserId {
    return _preferences!.getString(_userId)!;
  }

  static Future clearTokens() {
    return _preferences!.clear();
  }
}
