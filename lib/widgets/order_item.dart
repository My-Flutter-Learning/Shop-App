import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as od;

class OrderItem extends StatefulWidget {
  final od.OrderItem order;
  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      color: Colors.white,
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text(
            '\$${widget.order.amount!.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.black),
          ),
          subtitle: Text(
            DateFormat('dd MMMM, yyyy hh:mm a').format(widget.order.dateTime!),
            style: const TextStyle(color: Colors.black),
          ),
          trailing: IconButton(
            icon: _expanded
                ? const Icon(
                    Icons.expand_more,
                    color: Colors.black,
                  )
                : const Icon(
                    Icons.expand_less,
                    color: Colors.black,
                  ),
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
        ),
        if (_expanded)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            height: min(widget.order.products!.length * 20.0 + 100, 180),
            child: ListView(
              children: widget.order.products!
                  .map(
                    (prod) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            prod.title!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '${prod.quantity!} x \$${prod.price!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
      ]),
    );
  }
}
