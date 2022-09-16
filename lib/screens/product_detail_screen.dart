import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/productdetail';
  // final String title;

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool sysTheme = ThemeData.light().useMaterial3;
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title!)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/image_placeholder.jpg',
                image: loadedProduct.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: sysTheme ? Colors.grey : Colors.grey[350],
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                loadedProduct.description!,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(color: sysTheme ? Colors.black : Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
