import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(children: [
        Card(
          margin: const EdgeInsets.all(15),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                const Spacer(), //takes up all the vailable space and recserves it for itself
                Chip(
                  label: Text(
                    '\$${cart.totalAmount}',
                    style: TextStyle(
                        color: Theme.of(context)
                            .primaryTextTheme
                            .titleLarge!
                            .color),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                TextButton(onPressed: () {}, child: const Text('ORDER NOW'))
              ],
            ),
          ),
        ),
        const SizedBox(height: 10,),
        Expanded(
            child: ListView.builder(
                itemBuilder: ((context, i) => 
                    CartItem(
                        cart.items.values.toList()[i].id,
                        cart.items.values.toList()[i].price,
                        cart.items.values.toList()[i].quantity,
                        cart.items.values.toList()[i].title)),
                itemCount: cart.itemCount,))
      ]),
    );
  }
}
