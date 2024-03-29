import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' as pc;
import '../utils/theme.dart';

class CartItem extends StatelessWidget {
  final String? id;
  final String? productId;
  final double? price;
  final int? quantity;
  final String? title;

  const CartItem(this.id, this.productId, this.price, this.quantity, this.title,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text(
                    'Are you sure?',
                  ),
                  content: const Text(
                      'Confirm deletion of the selected item from the shopping cart.'),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(false);
                            },
                            child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    )
                  ],
                ));
      },
      onDismissed: (direction) {
        Provider.of<pc.Cart>(context, listen: false).removeItem(productId!);
      },
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text(
                    '\$${price!.toStringAsFixed(2)}',
                    style: const TextStyle(color: MyTheme.sec2Color),
                  ),
                ),
              ),
              backgroundColor: MyTheme.baseColor,
            ),
            title: Text(title!),
            subtitle: Text('Total: \$${(price! * quantity!)}'),
            trailing: Text('x $quantity'),
          ),
        ),
      ),
    );
  }
}
