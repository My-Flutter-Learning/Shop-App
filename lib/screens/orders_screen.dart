import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shop_app/widgets/bottom_navbar.dart';

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
  late Future _ordersFuture;
  int pageIndex = 1;

  Future _obtainOtdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOtdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color sec2Color = const Color.fromARGB(255, 50, 128, 52);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: sec2Color),
        title: Text(
          'Your Orders',
          style: TextStyle(color: sec2Color),
        ),
      ),
      drawer: const SideDrawer(),
      body: FutureBuilder(
          future: _ordersFuture,
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
          })),
      // bottomNavigationBar: BottomNavBar(pageIndex),
    );
  }
}
