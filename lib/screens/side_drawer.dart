import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/custom_route.dart';
import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
import '../utils/theme.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(children: [
        AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          toolbarHeight: 150,
          title: const Text(
            'Hello Friend!',
            style: TextStyle(color: Colors.black),
          ),
          automaticallyImplyLeading: false,
        ),
        const Divider(
          color: Colors.white,
        ),
        ListTile(
          leading: const Icon(Icons.shop, color: MyTheme.sec2Color),
          title: const Text(
            'Shop',
            style: TextStyle(color: MyTheme.sec2Color),
          ),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        const Divider(
          color: Colors.white,
        ),
        ListTile(
          leading: const Icon(
            Icons.credit_card,
            color: MyTheme.sec2Color,
          ),
          title: const Text(
            'Orders',
            style: TextStyle(color: MyTheme.sec2Color),
          ),
          onTap: () {
            // Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            Navigator.of(context).pushReplacement(CustomRoute(
              builder: ((context) => const OrdersScreen()),
              settings: const RouteSettings(),
            ));
          },
        ),
        const Divider(
          color: Colors.white,
        ),
        ListTile(
          leading: const Icon(
            Icons.edit,
            color: MyTheme.sec2Color,
          ),
          title: const Text(
            'Manage Products',
            style: TextStyle(color: MyTheme.sec2Color),
          ),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        const Divider(
          color: Colors.white,
        ),
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.grey[600],
          ),
          title: Text(
            'Logout',
            style: TextStyle(color: Colors.grey[700]),
          ),
          onTap: () {
            Navigator.of(context)
                .pop(); // Closes the side drawer before logging out
            Navigator.of(context).pushReplacementNamed('/');
            Provider.of<Auth>(context, listen: false).logout();
          },
        )
      ]),
    );
  }
}
