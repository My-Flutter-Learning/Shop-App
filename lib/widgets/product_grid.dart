import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool? showFavs;
  const ProductsGrid(this.showFavs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final products = showFavs! ? productsData.showFavourites : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder:
          /* Use this approach of you do not need the context.
        It is also the approach to be used when you are using already existing data
       and not creating an new instance of a class a is happening in the main.dart file */
          // The provider is directly tied to the data it is providing for.
          /* This approach should be used when you are providing data to single list or grid item
        as it does not bring up any errors especially when the list becomes long and scrollable.
        This is because Flutter recycles widgets and only changes the data in them.
        The previous approach would have not been able to keep up with this.*/
          (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // products[i].id!,
            // products[i].title!,
            // products[i].imageUrl!
            key: Key(products[i].id!),
            ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5 / 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
