import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/loading_spinner.dart';
import '../widgets/order_item.dart';
import '../screens/side_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Your Orders')),
        drawer: const SideDrawer(),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: ((context, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const LoadingSpinner(
                  text: 'Retrieving Data',
                );
              }
              if (dataSnapshot.error != null) {
                return const Center(
                  child: Text('An error occurred'),
                );
              } else {
                return Consumer<Orders>(
                    builder: (ctx, orderData, child) => ListView.builder(
                          itemBuilder: ((context, i) =>
                              OrderItem(orderData.orders[i])),
                          itemCount: orderData.orders.length,
                        ));
              }
            })));
  }
}
