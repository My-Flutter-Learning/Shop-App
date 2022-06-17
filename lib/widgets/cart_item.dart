import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String? id;
  final double? price;
  final int? quantity;
  final String? title;

  const CartItem(this.id, this.price, this.quantity, this.title, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: FittedBox(child: Text('\$$price')),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          title: Text(title!),
          subtitle: Text('Total: \$${(price! * quantity!)}'),
          trailing: Text('x $quantity'),
        ),
      ),
    );
  }
}
