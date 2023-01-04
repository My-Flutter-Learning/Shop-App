import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
// import 'package:shop_app/widgets/bottom_navbar.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/loading_spinner.dart';
import '../widgets/order_item.dart';
import '../screens/side_drawer.dart';
import '../utils/theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: MyTheme.sec2Color),
        title: const Text(
          'Your Orders',
          style: TextStyle(color: MyTheme.sec2Color),
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
              log("Orders_Screen: " + dataSnapshot.error.toString());
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.list_alt,
                      color: Colors.grey,
                      size: 50,
                    ),
                    Text(
                      'No orders',
                      style: TextStyle(color: Colors.grey[600], fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: (() => Navigator.of(context)
                          .pushNamed(ProductsOverviewScreen.routeName)),
                      child: const Text('Create One'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyTheme.sec2Color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ],
                ),
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
