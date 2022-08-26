import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/loading_spinner.dart';
import '../widgets/order_item.dart';
import '../screens/side_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) async {

    _isLoading = true;

    Provider.of<Orders>(context, listen: false)
        .fetchAndSetOrders()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });

    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders')),
      drawer: const SideDrawer(),
      body: _isLoading
          ? const LoadingSpinner(
              text: 'Retrieving Data',
            )
          : ListView.builder(
              itemBuilder: ((context, i) => OrderItem(orderData.orders[i])),
              itemCount: orderData.orders.length,
            ),
    );
  }
}
