import 'package:flutter/material.dart';
import 'package:my_home_app/shop_page.dart'; // For MenuItem

class CartItem {
  final MenuItem menuItem;
  final String shopName;
  int quantity;

  CartItem({required this.menuItem, required this.shopName, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(MenuItem menuItem, String shopName) {
    final existingItemIndex = _items.indexWhere(
        (item) => item.menuItem.name == menuItem.name && item.shopName == shopName);

    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity++;
    } else {
      _items.add(CartItem(menuItem: menuItem, shopName: shopName));
    }
    notifyListeners();
  }

  void decrementItem(String itemName, String shopName) {
    final existingItemIndex = _items.indexWhere(
        (item) => item.menuItem.name == itemName && item.shopName == shopName);

    if (existingItemIndex >= 0) {
      if (_items[existingItemIndex].quantity > 1) {
        _items[existingItemIndex].quantity--;
      } else {
        _items.removeAt(existingItemIndex);
      }
      notifyListeners();
    }
  }

  void removeItem(String itemName, String shopName) {
    _items.removeWhere(
        (item) => item.menuItem.name == itemName && item.shopName == shopName);
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      total += item.menuItem.price * item.quantity;
    }
    return total;
  }

  int get itemCount {
    int count = 0;
    for (var item in _items) {
      count += item.quantity;
    }
    return count;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
