import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/cart.dart';
import 'package:shop_app/models/providers/product.dart';
import 'package:shop_app/screens/product_detail.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  Widget _buildIcon(
    Widget icon,
    VoidCallback onPressed,
    BuildContext context,
  ) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      // color: Theme.of(context).colorScheme.primary,
      color: Colors.amber,
    );
  }

  void _navitageToDetailScreen(BuildContext context, String id) {
    Navigator.of(context)
        .pushNamed(ProductDetailScreen.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final _product = Provider.of<Product>(context);
    final _cartContainer = Provider.of<CartProvider>(context, listen: false);
    return GridTile(
      child: InkWell(
        onTap: () => _navitageToDetailScreen(context, _product.id),
        child: Image.network(
          _product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        title: FittedBox(
          child: Text(
            _product.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        leading: Consumer<Product>(
          // when using customer you should set provider listen to false;
          // use consumer only to the part that rebuilds once click triggers
          builder: (context, value, child) => _buildIcon(
            Icon(
              _product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            () {
              _product.toggleIsFavorite();
            },
            context,
          ),
          // child: Text(''), // can be use when there is widget you want to rebuild inside customer it will reference to child params in builder
        ),
        trailing: _buildIcon(
          const Icon(Icons.shopping_cart),
          () {
            _cartContainer.addItem(
              _product.id,
              _product.price,
              _product.title,
            );
          },
          context,
        ),
      ),
    );
  }
}
