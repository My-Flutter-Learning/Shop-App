import 'package:flutter/material.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import '../screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato,'
      ),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName:(context) => const ProductDetailScreen(),
      },
    );
  }
}
