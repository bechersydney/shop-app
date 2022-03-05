import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget _buildListTile(
    String title,
    IconData icon,
    VoidCallback tapHandler,
    BuildContext context,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(title, style: Theme.of(context).textTheme.headline1),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello'),
            automaticallyImplyLeading: false,
          ),
          const SizedBox(
            height: 10,
          ),
          _buildListTile('Shop', Icons.shopping_cart, () {
            Navigator.of(context).pushReplacementNamed('/');
          }, context),
          const Divider(),
          _buildListTile('Orders', Icons.payment, () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          }, context),
        ],
      ),
    );
  }
}
