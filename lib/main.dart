import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';
import './screens/cart_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';

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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          /*This approach shuld be used when creating an new instance of an object
        and you want to provide it to other widgets*/
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Shop App',
        theme: ThemeData(
            fontFamily: 'Lato,',
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                .copyWith(secondary: Colors.deepOrange)),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          CartScreen.routeName: ((context) => const CartScreen()),
          OrdersScreen.routeName: ((context) => const OrdersScreen()),
          UserProductsScreen.routeName: ((context) =>
              const UserProductsScreen()),
          EditProductScreen.routeName: ((context) => const EditProductScreen())
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
