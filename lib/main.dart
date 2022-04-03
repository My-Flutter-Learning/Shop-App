import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    /* Wrap the main widget with the ChangeNotifierProvider widget.
    This allows us to add listeners to other widgets which rebuild
    when any data in the provider class changes.
    In this case, the provider class is Products()  which we are
    calling using the create function.
    The create function provides an instance of Products() to all
    child widgets of MaterialApp.*/

    return ChangeNotifierProvider(
      create: (context) => Products(),
      child: MaterialApp(
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
      ),
    );
  }
}
