import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/order.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/order-page';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // this approach will avoid the future run again once the state is changed that trigger build
  late Future _ordersFuture;
  @override
  void initState() {
    _ordersFuture =
        Provider.of<OrdersProvider>(context, listen: false).fetchAndSetOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occured'),
              );
            }
            return Consumer<OrdersProvider>(
              builder: (context, orderProvider, child) => ListView.builder(
                itemBuilder: (context, index) => OrderItem(
                  orderProvider.orders[index],
                ),
                itemCount: orderProvider.orders.length,
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
