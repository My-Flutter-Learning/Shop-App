import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color sec2Color = const Color.fromARGB(255, 50, 128, 52);
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
        const Divider(),
        ListTile(
          leading: Icon(Icons.shop, color: sec2Color),
          title: Text(
            'Shop',
            style: TextStyle(color: sec2Color),
          ),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(
            Icons.credit_card,
            color: sec2Color,
          ),
          title: Text(
            'Orders',
            style: TextStyle(color: sec2Color),
          ),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(
            Icons.edit,
            color: sec2Color,
          ),
          title: Text(
            'Manage Products',
            style: TextStyle(color: sec2Color),
          ),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
        )
      ]),
    );
  }
}
