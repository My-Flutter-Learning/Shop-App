import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import '../utils/shared_preferences.dart';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _userId;
  DateTime? _expiryDate;
  String? _token;
  bool _canAuthRun = true;
  Timer? _authTimer;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return UserPreferences().getUserToken;
    }
    _canAuthRun = false;
    return '';
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(urlSegment + "?key=" + FlutterConfig.get('API_KEY'));

    if (_canAuthRun) {
      try {
        final response = await http.post(
          url,
          body: json.encode(
            {
              'email': email,
              'password': password,
              'returnSecureToken': true,
            },
          ),
        );
        final responseData = json.decode(response.body);
        log(response.statusCode.toString(), name: "Auth Status Code");
        if (responseData['error'] != null) {
          throw HttpException(responseData['error']['message']);
        }
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])));
        UserPreferences.setUserToken(_token!);
        UserPreferences.setUserId(_userId!);
        _autoLogout();
        _canAuthRun = false;
        notifyListeners();
      } catch (error) {
        throw HttpException(error.toString());
      }
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, FlutterConfig.get('signup_url'));
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, FlutterConfig.get('login_url'));
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    UserPreferences.clearTokens();
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final _timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _timeToExpiry), logout);
  }
}
