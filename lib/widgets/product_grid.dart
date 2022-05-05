import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: 
      // Use this approach of you do not need the context.
      //The provider is directly tied to the data it is providing for.
      /*It is also the approach that should be used 
      when you are providing datah to single list or grid item as it does not bring up any errors
      especially when the list becomes long and scrollable. This is because Flutter recycles widgets
      and only changes the data in them. The previous approach would have not been able to keep up with this.*/
      (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: const ProductItem(
              // products[i].id!,
              // products[i].title!,
              // products[i].imageUrl!
            ),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
