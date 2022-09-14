import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static SharedPreferences? _preferences;
  static const userToken = 'token';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserToken(String token) async {
    await _preferences!.setString(userToken, token);
  }

  String get getUserToken {
    return _preferences!.getString(userToken)!;
  }
}
