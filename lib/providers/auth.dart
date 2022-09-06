import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  late String _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(urlSegment + "?key=" + FlutterConfig.get('API_KEY'));

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
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, FlutterConfig.get('signup_url'));
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, FlutterConfig.get('login_url'));
  }
}
