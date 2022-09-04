import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _userId;

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(FlutterConfig.get('API_URL') + "?key="  + FlutterConfig.get('API_KEY'));

    try {
      final response = http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
    } catch (error) {
      rethrow;
    }
  }
}
