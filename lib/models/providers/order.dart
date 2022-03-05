import 'package:flutter/material.dart';
import 'package:shop_app/models/providers/cart.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> cartItems;
  final DateTime dateTime;

  const Order({
    required this.id,
    required this.amount,
    required this.cartItems,
    required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double total) {
    _orders.insert(
      0,
      Order(
        id: DateTime.now().toString(),
        amount: total,
        cartItems: cartItems,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
