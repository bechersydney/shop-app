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

  Future<void> addProduct(Product _product) async {
    final _newProduct = Product(
      id: DateTime.now().toString(),
      title: _product.title,
      price: _product.price,
      description: _product.description,
      imageUrl: _product.imageUrl,
    );
    _items.insert(0, _newProduct);
    notifyListeners();
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
