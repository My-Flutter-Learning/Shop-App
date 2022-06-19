import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_products_screen.dart';
import '../screens/side_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);              
            },
          )
        ],
      ),
      drawer: const SideDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
            itemBuilder: ((_, i) => Column(
                  children: [
                    UserProductItem(productsData.items[i].title!,
                        productsData.items[i].imageUrl!),
                    const Divider(),
                  ],
                )),
            itemCount: productsData.items.length),
      ),
    );
  }
}
