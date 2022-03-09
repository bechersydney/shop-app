import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

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
    const _url =
        'https://shop-app-220d9-default-rtdb.firebaseio.com/product.json';
    final url = Uri.parse(_url);
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': _product.title,
            'price': _product.price,
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

    final updateUrl = Uri.parse(
        'https://shop-app-220d9-default-rtdb.firebaseio.com/product/$id.json');
    try {
      await http.patch(
        updateUrl,
        body: json.encode(
          {
            'title': _newProduct.title,
            'description': _newProduct.description,
            'price': _newProduct.price,
            'imageUrl': _newProduct.imageUrl,
          },
        ),
      );
    } catch (err) {
      print(err);
    }
    _items[_productIndex] = _newProduct;
    notifyListeners();
  }

  Future<void> deleteProductById(String id) async {
    _items.removeWhere((product) => product.id == id);
    final deleteUrl = Uri.parse(
        'https://shop-app-220d9-default-rtdb.firebaseio.com/product/$id.json');
    try {
      final response = await http.delete(deleteUrl);
      if (response.statusCode >= 400) {
        throw const HttpException('Could not delete product');
      }
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    const _url =
        'https://shop-app-220d9-default-rtdb.firebaseio.com/product.json';
    final url = Uri.parse(_url);
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadededProduct = [];
      extractedData.forEach((prodId, product) {
        loadededProduct.add(
          Product(
            id: prodId,
            description: product['description'],
            imageUrl: product['imageUrl'],
            price: product['price'],
            title: product['title'],
            isFavorite: product['isFavorite'],
          ),
        );
      });
      _items = loadededProduct;
      notifyListeners();
    } catch (err) {
      // ignore: avoid_print
      print(err);
    }
  }
}
