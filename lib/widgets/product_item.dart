import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  const ProductItem(/*this.id, this.title, this.imageUrl*/ {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context,
        listen:
            false); //We are telling the cart we added a new item. We are not listening to changes in the cart.
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: GridTile(
        child: GestureDetector(
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/image_placeholder.jpg',
            image: product.imageUrl!,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.6),
          // Using Consumer allows you to rebuild parts of the widget tree instead of the entire tree
          leading: Consumer<Product>(
            //since child is not needed we put an underscore
            builder: (context, product, _) => IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).colorScheme.secondary),
              onPressed: () {
                product.toggleFavouriteStatus();
              },
            ),
          ),
          title: Text(
            product.title!,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              cart.addItem(product.id!, product.price!, product.title!);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Added item to cart!'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: () {
                    cart.removeSingleItem(product.id!);
                  },
                ),
              ));
            },
          ),
        ),
      ),
    );
  }
}
