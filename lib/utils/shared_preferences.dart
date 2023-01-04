import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;
  static const _userToken = 'token';
  static const _userId = 'userid';
  static const _expiryDate = 'expiryDate';

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

  static Future setExpiryDate(DateTime expiryDate) async {
    await _preferences!.setString(_expiryDate, expiryDate.toIso8601String());
  }

  String get getExpiryDate {
    return _preferences!.getString(_expiryDate)!;
  }

  static Future clearTokens() {
    return _preferences!.clear();
  }
    
}
