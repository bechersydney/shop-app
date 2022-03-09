import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/models/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final getOrderUrl = Uri.parse(
        'https://shop-app-220d9-default-rtdb.firebaseio.com/orders.json');
    try {
      final response = await http.get(getOrderUrl);
      final extractedData = json.decode(response.body) != null
          ? json.decode(response.body) as Map<String, dynamic>
          : null;
      List<Order> loadedOrder = [];
      if (extractedData != null) {
        extractedData.forEach((key, order) {
          loadedOrder.add(
            Order(
              id: key,
              amount: order['amount'],
              cartItems: (order['cartItems'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                        id: item['id'],
                        title: item['title'],
                        quantity: item['quantity'],
                        price: item['price']),
                  )
                  .toList(),
              dateTime: DateTime.parse(order['dateTime']),
            ),
          );
        });
        _orders = loadedOrder.reversed.toList();
        notifyListeners();
      }

      if (response.statusCode >= 400) {
        throw const HttpException('Cannot fetch Orders');
      }
    } catch (err) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartItems, double total) async {
    final addOrderUrl = Uri.parse(
        'https://shop-app-220d9-default-rtdb.firebaseio.com/orders.json');
    final timeStamp = DateTime.now();

    try {
      final response = await http.post(
        addOrderUrl,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'cartItems': cartItems
              .map(
                (cartItem) => {
                  'id': cartItem.id,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  'price': cartItem.price
                },
              )
              .toList(),
        }),
      );
      if (response.statusCode >= 400) {
        print('save order failed!');
      } else {
        _orders.insert(
          0,
          Order(
            id: json.decode(response.body)['name'],
            amount: total,
            cartItems: cartItems,
            dateTime: timeStamp,
          ),
        );
        notifyListeners();
      }
    } catch (err) {
      throw err;
    }
  }
}
