import 'package:flutter/material.dart';

import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool sysTheme = ThemeData.light().useMaterial3;
    return Drawer(
      backgroundColor: sysTheme ? Colors.white : Colors.grey[900],
      child: Column(children: [
        AppBar(
          title: Text(
            'Hello Friend!',
            style: TextStyle(color: sysTheme ? Colors.black : Colors.white),
          ),
          automaticallyImplyLeading: false,
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.shop, color: sysTheme == true ? Colors.black : Colors.white,),
          title: Text(
            'Shop',
            style: TextStyle(color: sysTheme ? Colors.black : Colors.white),
          ),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.credit_card, color: sysTheme == true ? Colors.black : Colors.white,),
          title: Text(
            'Orders',
            style: TextStyle(color: sysTheme ? Colors.black : Colors.white),
          ),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.edit, color: sysTheme == true ? Colors.black : Colors.white,),
          title: Text(
            'Manage Products',
            style: TextStyle(color: sysTheme ? Colors.black : Colors.white),
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
