import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';
import '../utils/shared_preferences.dart';

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem>? products;
  final DateTime? dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final url = Uri.parse(
      'https://shop-app-6baad-default-rtdb.firebaseio.com/orders.json?auth=${UserPreferences().getUserToken}');

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final List<OrderItem> loadedOrders = [];
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['Amount'],
          dateTime: DateTime.parse(orderData['DateTime']),
          products: (orderData['Products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['Title'],
                  quantity: item['Quantity'],
                  price: item['Price']))
              .toList(),
        ));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'Amount': total,
          'DateTime': timestamp.toIso8601String(),
          'Products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'Title': cartProduct.title,
                    'Price': cartProduct.price,
                    'Quantity': cartProduct.quantity,
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timestamp));
    notifyListeners();
  }
}
