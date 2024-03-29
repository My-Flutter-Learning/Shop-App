import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/shared_preferences.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double? price;
  final String? imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void _rollBack(bool oldStatus) {
    isFavourite = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus() async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = Uri.parse(
        'https://shop-app-6baad-default-rtdb.firebaseio.com/userFavourites/${UserPreferences().getUserId}/$id.json?auth=${UserPreferences().getUserToken}');
    try {
      final response = await http.put(url,
          body: json.encode({
            'isFavourite': isFavourite,
          }));
      if (response.statusCode >= 400) {
        _rollBack(oldStatus);
      }
    } catch (error) {
      _rollBack(oldStatus);
    }
  }
}
