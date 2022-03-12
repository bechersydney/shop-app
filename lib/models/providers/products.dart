import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  String? _authToken;
  String? _userId;

  String? get getToken {
    return _authToken;
  }

  void updateToken(String? token) {
    _authToken = token;
  }

  void updateuserId(String? userId) {
    _userId = userId;
  }

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
    final _url =
        'https://shop-app-220d9-default-rtdb.firebaseio.com/product.json?auth=$_authToken';
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
            'userId': _userId,
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
      rethrow;
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
        'https://shop-app-220d9-default-rtdb.firebaseio.com/product/$id.json?auth=$_authToken');
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
      rethrow;
    }
    _items[_productIndex] = _newProduct;
    notifyListeners();
  }

  Future<void> deleteProductById(String id) async {
    _items.removeWhere((product) => product.id == id);
    final deleteUrl = Uri.parse(
        'https://shop-app-220d9-default-rtdb.firebaseio.com/product/$id.json?auth=$_authToken');
    try {
      final response = await http.delete(deleteUrl);
      if (response.statusCode >= 400) {
        throw const HttpException('Could not delete product');
      }
    } catch (err) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    final _url =
        'https://shop-app-220d9-default-rtdb.firebaseio.com/product.json?auth=$_authToken&orderBy="userId"&equalTo="$_userId"';
    final url = Uri.parse(_url);
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      final getFavUrl = Uri.parse(
          'https://shop-app-220d9-default-rtdb.firebaseio.com/userFavorites/$_userId.json?auth=$getToken');
      final res = await http.get(getFavUrl);
      final favData = json.decode(res.body);
      final List<Product> loadededProduct = [];
      extractedData.forEach((prodId, product) {
        loadededProduct.add(
          Product(
            id: prodId,
            description: product['description'],
            imageUrl: product['imageUrl'],
            price: product['price'],
            title: product['title'],
            isFavorite: favData == null ? false : favData[prodId] ?? false,
          ),
        );
      });
      _items = loadededProduct;
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }
}
