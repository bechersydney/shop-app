import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/orders.dart';
import 'package:shop_app/screens/user_products_screen.dart';

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
            Navigator.of(context).pop();
          }, context),
          const Divider(),
          _buildListTile('Manage Product', Icons.settings, () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName);
          }, context),
          const Divider(),
          _buildListTile('Log out', Icons.logout_outlined, () {
            Navigator.of(context).pushReplacementNamed('/');
            authProvider.logOut();
          }, context),
          const Divider(),
        ],
      ),
    );
  }
}
