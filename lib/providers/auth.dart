import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
    'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key='+ FlutterConfig.get('API_KEY'));
    
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      print(response.statusCode.toString());
    } catch (error) {
      rethrow;
    }
  }
}
