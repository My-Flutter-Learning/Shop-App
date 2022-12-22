import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/auth_screen.dart';

import '../providers/products_provider.dart';
// import '../widgets/bottom_navbar.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_products_screen.dart';
import '../screens/side_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshScreen(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    // int pageIndex = 2;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: sec2Color),
        title: Text(
          'Your Products',
          style: TextStyle(color: sec2Color),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName,
                  arguments: 'newProduct');
            },
          )
        ],
      ),
      drawer: const SideDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshScreen(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
              itemBuilder: ((_, i) => Column(
                    children: [
                      UserProductItem(
                          productsData.items[i].id!,
                          productsData.items[i].title!,
                          productsData.items[i].imageUrl!),
                      const Divider(),
                    ],
                  )),
              itemCount: productsData.items.length),
        ),
      ),
      // bottomNavigationBar: BottomNavBar(pageIndex),
    );
  }
}
