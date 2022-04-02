import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/productdetail';
  // final String title;

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text('title')),
    );
  }
}
