import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const ProductItem(this.id, this.title, this.imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
        child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/image_placeholder.jpg',
            image: imageUrl, 
            fit: BoxFit.cover,
          ),
        footer: GridTileBar(
              backgroundColor: Colors.black.withOpacity(0.6),
              leading: IconButton(icon: Icon(Icons.favorite_border), onPressed: null,),
              title: Text(
                  title,
                  textAlign: TextAlign.center,
                ),
              trailing: IconButton(icon: Icon(Icons.shopping_cart), onPressed: null,),
            ),
      );
  }
}
