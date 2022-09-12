import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _userId;
  DateTime? _expiryDate;
  String? _token;
  bool _canAuthRun = true;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
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
        if (responseData['error'] != null) {
          throw HttpException(responseData['error']['message']);
        }
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now()
            .add(Duration(seconds: int.parse(responseData['expiresIn'])));
        notifyListeners();
      } catch (error) {
        throw HttpException(error.toString());
      }
    }
  }

  Future<void> signup(String email, String password) async {
    _canAuthRun = false;
    return _authenticate(email, password, FlutterConfig.get('signup_url'));
  }

  Future<void> login(String email, String password) async {
    _canAuthRun = false;
    return _authenticate(email, password, FlutterConfig.get('login_url'));
  }
}
