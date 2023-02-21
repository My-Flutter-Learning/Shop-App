import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop_app/widgets/bottom_navbar.dart';

import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../widgets/badge.dart'as bg;
import '../widgets/loading_spinner.dart';
import '../widgets/product_grid.dart';
import '../screens/cart_screen.dart';
import '../screens/side_drawer.dart';
import '../utils/theme.dart';

enum FilterOptions { favourites, all }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/productsOverviewScreen';
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showFavouritesOnly = false;
  var _isInit = true;
  var _isLoading = false;
  int pageIndex = 0;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProducts(); //won't work. This is because context is not available in initState
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchAndSetProducts();
    // }); // This is a workaround that work that one can use.
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit =
        false; // This ensures that the fetchAndSetProducts method runs only once since didChangeDependencies runs multiple times.
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'MyShop',
          style: TextStyle(color: MyTheme.sec2Color),
        ),
        iconTheme: const IconThemeData(color: MyTheme.sec2Color),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favourites) {
                    _showFavouritesOnly = true;
                  } else {
                    _showFavouritesOnly = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                        child: Text('Only Favourites'),
                        value: FilterOptions.favourites),
                    const PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.all,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cartData, ch) => bg.Badge(
              value: cartData.itemCount.toString(),
              child: ch,
              color: MyTheme.sec2Color,
            ),
            child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          )
        ],
      ),
      drawer: const SideDrawer(),
      body: _isLoading
          ? const LoadingSpinner(
              text: '',
            )
          : ProductsGrid(_showFavouritesOnly),
      // bottomNavigationBar: BottomNavBar(pageIndex),
    );
  }
}
