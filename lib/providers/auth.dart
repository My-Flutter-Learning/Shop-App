import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _userId;
  late int loginStatusCode = 0;
  late int signupStatusCode = 0;

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(FlutterConfig.get('signup_url') +
        "?key=" +
        FlutterConfig.get('API_KEY'));

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
      signupStatusCode = response.statusCode;
      print("Signup: " + response.statusCode.toString());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(FlutterConfig.get('login_url') +
        "?key=" +
        FlutterConfig.get('API_KEY'));

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
      loginStatusCode = response.statusCode;
      print("Login: " + response.statusCode.toString());
    } catch (error) {
      rethrow;
    }
  }
}
