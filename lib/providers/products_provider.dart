import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  // var _showFavouritesonly = false;
  int editCount = 0;

  List<Product> get items {
    // if (_showFavouritesonly) {
    //   return _items.where((prodItem) => prodItem.isFavourite).toList();
    // }
    //return a copy of the items list
    return [..._items];
  }

  List<Product> get showFavourites {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // void showFavouritesOnly() {
  //   _showFavouritesonly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavouritesonly = false;
  //   notifyListeners();
  // }

  final url = Uri.parse(
      'https://shop-app-6baad-default-rtdb.firebaseio.com/products.json');

  Future<void> fetchAndSetProducts() async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['Title'],
            description: prodData['Description'],
            price: prodData['Price'],
            imageUrl: prodData['Image Url'],
            isFavourite: prodData['isFavourite']));
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
            'isFavourite': product.isFavourite,
            'Product Added': DateTime.now().toString(),
            'Product Edited': null,
            'Edit Count': editCount
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
      print(error);
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product upd) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shop-app-6baad-default-rtdb.firebaseio.com/products/$id.json');
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
            'Product Edited': DateTime.now().toString(),
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
        'https://shop-app-6baad-default-rtdb.firebaseio.com/products/$id.jon');
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
