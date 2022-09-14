import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

import './providers/auth.dart' as auth;
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';
import './screens/auth_screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
// import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';
import './utils/shared_preferences.dart';

void main() async {
  // Required for FlutterConfig and Shared Preferences to work.
  WidgetsFlutterBinding.ensureInitialized();

  // Allows me to access the env file
  await FlutterConfig.loadEnvVariables();

  // Initializes shared preferences
  await UserPreferences.init();


// This creates a temporary directory in the user's device for storing Firebase Credentials.
  final tempDir = await getTemporaryDirectory();
  final file = File('${tempDir.path}/service-account.json');
  final data = json.encode({
    "type": FlutterConfig.get('type'),
    "project_id": FlutterConfig.get('project_id'),
    "private_key_id": FlutterConfig.get('private_key_id'),
    "private_key": FlutterConfig.get('private_key'),
    "client_email": FlutterConfig.get('client_email'),
    "client_id": FlutterConfig.get('client_id'),
    "auth_uri": FlutterConfig.get('auth_uri'),
    "token_uri": FlutterConfig.get('token_uri'),
    "auth_provider_x509_cert_url":
        FlutterConfig.get('auth_provider_x509_cert_url'),
    "client_x509_cert_url": FlutterConfig.get('client_x509_cert_url'),
  });
  await file.writeAsString(data);

  // Initializing Firebase Admin to allow me to do CRUD operations to user data
  FirebaseAdmin.instance.initializeApp(
    AppOptions(
      credential: FirebaseAdmin.instance.certFromPath(file.path),
    ),
  );

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
            create: (context) => auth.Auth(),
          ),
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
        child: Consumer<auth.Auth>(
          builder: ((context, authData, _) => MaterialApp(
                title: 'Shop App',
                theme: ThemeData(
                    fontFamily: 'Lato,',
                    colorScheme:
                        ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                            .copyWith(secondary: Colors.deepOrange)),
                home: authData.isAuth
                    ? const ProductsOverviewScreen()
                    : const AuthScreen(),
                routes: {
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
