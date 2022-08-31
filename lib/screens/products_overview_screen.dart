import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/bottom_navbar.dart';

import '../providers/cart.dart';
import '../providers/products_provider.dart';
import '../widgets/badge.dart';
import '../widgets/loading_spinner.dart';
import '../widgets/product_grid.dart';
import '../screens/cart_screen.dart';
import '../screens/side_drawer.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
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
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
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
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favourites) {
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
                        value: FilterOptions.Favourites),
                    const PopupMenuItem(
                      child: Text('Show All'),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              value: cartData.itemCount.toString(),
              child: ch,
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                }),
          )
        ],
      ),
      // drawer: const SideDrawer(),
      body: _isLoading
          ? const LoadingSpinner(
              text: '',
            )
          : ProductsGrid(_showFavouritesOnly),
      // bottomNavigationBar: BottomNavBar(pageIndex),
    );
  }
}
