import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/utils/network_service.dart';
import 'package:shop_app/utils/temp_storage.dart';

import './providers/auth.dart' as auth;
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/user_products_screen.dart';
import './screens/splash_screen.dart';
import './utils/shared_preferences.dart';

void main() async {
  // Required for FlutterConfig and Shared Preferences to work.
  WidgetsFlutterBinding.ensureInitialized();

  // Allows me to access the env file
  await FlutterConfig.loadEnvVariables();

  // Initializes shared preferences
  await UserPreferences.init();

  TemporaryStorage.service();

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
          StreamProvider(
              create: ((context) => NetworkService().controller.stream),
              initialData: NetworkStatus.online),
          ChangeNotifierProvider(
            create: (context) => auth.Auth(),
          ),
          ChangeNotifierProvider(
            /*This approach shuld be used when creating an new instance of an object
        and you want to provide it to other widgets*/
            create: (context) => ProductsProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (context) => Orders(),
          )
        ],
        child: Consumer<auth.Auth>(
          builder: ((context, authData, _) => MaterialApp(
                title: 'Shop App',
                theme: ThemeData(
                  fontFamily: 'Lato,',
                ),
                themeMode: ThemeMode.system,
                // darkTheme: MyTheme.darkTheme,

                home: authData.isAuthenticated
                    ? const ProductsOverviewScreen()
                    : FutureBuilder(
                        builder: ((context, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashScreen()
                                : const AuthScreen()),
                        future: authData.tryAutoLogin().then((value) => log(value.toString(), name: "AutoLogin Value")),
                      ),
                routes: {
                  SplashScreen.routeName: (context) => const SplashScreen(),
                  ProductsOverviewScreen.routeName: (context) =>
                      const ProductsOverviewScreen(),
                  ProductDetailScreen.routeName: (context) =>
                      const ProductDetailScreen(),
                  CartScreen.routeName: ((context) => const CartScreen()),
                  OrdersScreen.routeName: ((context) => const OrdersScreen()),
                  UserProductsScreen.routeName: ((context) =>
                      const UserProductsScreen()),
                  EditProductScreen.routeName: ((context) =>
                      const EditProductScreen())
                },
                debugShowCheckedModeBanner: false,
              )),
        ));
  }
}
