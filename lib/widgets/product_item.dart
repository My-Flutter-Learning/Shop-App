import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  const ProductItem(/*this.id, this.title, this.imageUrl*/ {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
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
          leading: IconButton(
            icon: Icon( product.isFavourite ? Icons.favorite_border : Icons.favorite,
                color: Theme.of(context).accentColor),
            onPressed: () {
              product.toggleFavouriteStatus();
            },
          ),
          title: Text(
            product.title!,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon:
                Icon(Icons.shopping_cart, color: Theme.of(context).accentColor),
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
