import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  final String API_KEY = 'AIzaSyAlVKczlPhhj50hvHcukfgIUPInWqzMxv0';
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuthenticated {
    return getToken != null;
  }

  String? get getToken {
    if (_token != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get getuserId {
    return _userId;
  }

  Future<void> _authenticate(
      {required final String email,
      required String password,
      String urlSegment = ''}) async {
    final _url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$API_KEY';
    final url = Uri.parse(_url);
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      notifyListeners();
    } catch (err) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(
        email: email, password: password, urlSegment: 'signUp');
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate(
        email: email, password: password, urlSegment: 'signInWithPassword');
  }

  void logOut() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }
}
