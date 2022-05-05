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

    // Use this approcach if you do not need the context
    return ChangeNotifierProvider.value(
      value: Products(),
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
            fontFamily: 'Lato,', colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(secondary: Colors.deepOrange)
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName:(context) => const ProductDetailScreen(),
        },
      ),
    );
  }
}
