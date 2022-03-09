import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/cart.dart';
import 'package:shop_app/models/providers/order.dart';
import 'package:shop_app/screens/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartContainer = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(
              15,
            ),
            child: Padding(
              padding: const EdgeInsets.all(
                8,
              ),
              child: Row(
                children: [
                  Text(
                    'Total',
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  const Spacer(),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      '\$ ${cartContainer.getTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderButton(cartContainer: cartContainer),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => SingleCartItem(
                cartContainer.items.values.toList()[index],
                cartContainer.items.keys.toList()[index],
              ), //getting only the value of map items.values.toList
              itemCount: cartContainer.getCartCount,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartContainer,
  }) : super(key: key);

  final CartProvider cartContainer;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartContainer.getTotal <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<OrdersProvider>(
                context,
                listen: false,
              ).addOrder(
                widget.cartContainer.items.values.toList(),
                widget.cartContainer.getTotal,
              );
              setState(() {
                _isLoading = false;
              });
              widget.cartContainer.clear();
              Navigator.of(context).pushNamed(OrdersScreen.routeName);
            },
      child:
      
       _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const Text('ORDER NOW'),
    );
  }
}
