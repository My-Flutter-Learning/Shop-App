import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as od;

class OrderItem extends StatelessWidget {
  final od.OrderItem order;
  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${order.amount}'),
          subtitle:
              Text(DateFormat('dd MM yyyy hh:mm').format(order.dateTime!)),
          trailing: IconButton(
            icon: const Icon(Icons.expand_more),
            onPressed: () {},
          ),
        )
      ]),
    );
  }
}
