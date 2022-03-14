import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/models/providers/order.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  const OrderItem(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _isExpanded
          ? min(widget.order.cartItems.length * 20 + 200, 250)
          : 105,
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '\$${widget.order.amount.toStringAsFixed(2)}',
              ),
              subtitle: Text(
                DateFormat.yMMMMEEEEd().format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8),
              height: _isExpanded
                  ? min(widget.order.cartItems.length * 20 + 100, 350)
                  : 0,
              child: ListView.builder(
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FittedBox(
                            child: Text(
                              '\$${widget.order.cartItems[index].price}',
                            ),
                          ),
                        ),
                      ),
                      Text(
                        widget.order.cartItems[index].title,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Text(
                        '${widget.order.cartItems[index].quantity} pcs',
                      ),
                    ],
                  ),
                ),
                itemCount: widget.order.cartItems.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
