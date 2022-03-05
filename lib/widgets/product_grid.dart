import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/products.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool _showFavs;
  const ProductGrid(
    this._showFavs, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<ProductsProvider>(context);
    final products =
        _showFavs ? productData.getFavorites : productData.getProducts;
    return GridView.builder(
      padding: const EdgeInsets.all(20.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          // use value only if you are recyling old widgets to render
          // create: (context) => products[  // use only on builder
          //     index], // since product is also mixin with changenotifier It will be automatically considered as Provider
          value: products[index],
          child: const ProductItem(),
        );
      },
    );
  }
}
