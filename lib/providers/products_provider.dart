import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import '../utils/shared_preferences.dart';

import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  var _showFavouritesonly = false;
  int editCount = 0;

  List<Product> get items {
    if (_showFavouritesonly) {
      return _items.where((prodItem) => prodItem.isFavourite).toList();
    }
    //return a copy of the items list
    return [..._items];
  }

  List<Product> get showFavourites {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void showFavouritesOnly() {
    _showFavouritesonly = true;
    notifyListeners();
  }

  // void showAll() {
  //   _showFavouritesonly = false;
  //   notifyListeners();
  // }
  final url = Uri.parse(
      'https://shop-app-6baad-default-rtdb.firebaseio.com/products.json?auth=${UserPreferences().getUserToken}');

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      log(extractedData.toString());
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      final favouritesUrl = Uri.parse(
          'https://shop-app-6baad-default-rtdb.firebaseio.com/userFavourites/${UserPreferences().getUserId}.json?auth=${UserPreferences().getUserToken}');
      final favResponse = await http.get(favouritesUrl);
      final favData = json.decode(favResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
            id: prodId,
            title: prodData['Title'],
            description: prodData['Description'],
            price: prodData['Price'],
            imageUrl: prodData['Image Url'],
            isFavourite: favData == null ? false : favData[prodId]['isFavourite'],
          ),
        );
        // loadedProducts.add(
        //   Product(
        //     id: prodId,
        //     title: prodData['Title'],
        //     description: prodData['Description'],
        //     price: prodData['Price'],
        //     imageUrl: prodData['Image Url'],
        //     isFavourite: favData[prodId] == null
        //         ? false
        //         : favData[prodId]['isFavourite'],
        //   ),
        // );
      });
      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProducts(Product product) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            'Title': product.title,
            'Description': product.description,
            'Price': product.price,
            'Image Url': product.imageUrl,
            'Product Added': DateTime.now().toIso8601String(),
            'Product Edited': null,
            'Edit Count': editCount,
            'creatorId': UserPreferences().getUserId,
          }));

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct); // add at the end of the list
      // _items.insert(0, newProduct); // add at the beginning of the list
      notifyListeners();
    } catch (error) {
      // Prints error on log console
      log(error.toString(), name: "Add Products", error: error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product upd) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-app-6baad-default-rtdb.firebaseio.com/products/$id.json?auth=${UserPreferences().getUserToken}');
      // The ocde below is for getting the edit count.
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      print(extractedData);
      await http.patch(url,
          body: json.encode({
            'Title': upd.title,
            'Description': upd.description,
            'Image Url': upd.imageUrl,
            'Price': upd.price,
            'Product Edited': DateTime.now().toIso8601String(),
            'Edit Count': extractedData['Edit Count'] + 1,
          }));
      _items[prodIndex] = upd;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    // This is optimistic updating.
    // It helps with rollback if the delete fails.
    // The  product to be deleted will be returned to the list of items and will be displayed.
    final url = Uri.parse(
        'https://shop-app-6baad-default-rtdb.firebaseio.com/products/$id.json?auth=${UserPreferences().getUserToken}');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
