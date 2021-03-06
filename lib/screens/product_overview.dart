// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/providers/cart.dart';
import 'package:shop_app/models/providers/products.dart';
import 'package:shop_app/screens/cart.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/product_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  static const String routeName = '/product-screen';
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _isShowFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.purple),
        title: const Text('Product Overview'),
        actions: [
          Consumer<CartProvider>(
            builder: (context, value, child) => Badge(
              child: child!,
              value: value.getCartCount,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (value) => {
              // getItems is listenig to this that why it updates
              setState(() {
                if (value == FilterOptions.Favorites) {
                  _isShowFavorites = true;
                } else {
                  _isShowFavorites = false;
                }
              })
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                child: Text('Favorites'),
                value: FilterOptions.Favorites,
              ),
              const PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<ProductsProvider>(context, listen: false)
            .fetchAndSetProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occured'),
              );
            }
            return ProductGrid(_isShowFavorites);
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
