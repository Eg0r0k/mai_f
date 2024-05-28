import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;


  late SharedPreferences _prefs;

  CartProvider() {
    _initPrefs();
  }


  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  
    _loadCartData();
  }


  void _loadCartData() {
    final List<String>? cartData = _prefs.getStringList('cart');
    if (cartData != null) {
      _cartItems.clear();
      _cartItems.addAll(
          cartData.map((item) => Map<String, dynamic>.from(json.decode(item))));
      notifyListeners();
    }
  }


  Future<void> _saveCartData() async {
    final List<String> cartData =
        _cartItems.map((item) => json.encode(item)).toList();
    await _prefs.setStringList('cart', cartData);
  }

  void addToCart(Map<String, dynamic> product) {
    final existingProductIndex =
        _cartItems.indexWhere((item) => item['id'] == product['id']);
    if (existingProductIndex >= 0) {
      _cartItems[existingProductIndex]['quantity'] += 1;
    } else {
      _cartItems.add({...product, 'quantity': 1});
    }
    _saveCartData(); 
    notifyListeners();
  }

  void removeFromCart(String productId) {
    final existingProductIndex =
        _cartItems.indexWhere((item) => item['id'] == productId);
    if (existingProductIndex >= 0) {
      if (_cartItems[existingProductIndex]['quantity'] > 1) {
        _cartItems[existingProductIndex]['quantity'] -= 1;
      } else {
        _cartItems.removeAt(existingProductIndex);
      }
      _saveCartData();
      notifyListeners();
    }
  }

  void removeAllFromCart(String productId) {
    _cartItems.removeWhere((item) => item['id'] == productId);
    _saveCartData();
    notifyListeners();
  }

  void placeOrder() {
    _cartItems.clear();
    _saveCartData();
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }
}
