import 'package:flutter/material.dart';
import 'package:shop_app/models/data/products.dart';
import 'product.dart';

class ProductsProvider with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get getProducts {
    // if (_showFavoritesOnly) {
    //   return _items.where((product) => product.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get getFavorites {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product getProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }
}
