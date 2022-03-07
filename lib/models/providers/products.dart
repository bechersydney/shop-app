import 'package:flutter/material.dart';
import 'package:shop_app/models/data/products.dart';
import 'product.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

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

  Future<void> addProduct(Product _product) async {
    final url =
        Uri.parse('https://shop-app-220d9-default-rtdb.firebaseio.com/product');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': _product.title,
            'pricce': _product.price,
            'description': _product.description,
            'imageUrl': _product.imageUrl,
            'isFavorite': _product.isFavorite,
          },
        ),
      );
      final _newProduct = Product(
        id: json.decode(response.body)['name'],
        title: _product.title,
        price: _product.price,
        description: _product.description,
        imageUrl: _product.imageUrl,
      );
      _items.add(_newProduct);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> updateProductById(String id, Product _newProduct) async {
    final _productIndex = _items.indexWhere((prod) => prod.id == id);
    _items[_productIndex] = _newProduct;
    notifyListeners();
  }

  Future<void> deleteProductById(String id) async {
    _items.removeWhere((product) => product.id == id);
    notifyListeners();
  }
}
