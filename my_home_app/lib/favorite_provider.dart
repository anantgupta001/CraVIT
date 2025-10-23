import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For json encoding/decoding
import 'package:cravit/shop_page.dart'; // Import MenuItem

class FavoriteProvider with ChangeNotifier {
  List<MenuItem> _favoriteItems = [];
  List<MenuItem> get favoriteItems => _favoriteItems;

  FavoriteProvider() {
    _loadFavoriteItems();
  }

  void _loadFavoriteItems() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteItemsString = prefs.getStringList('favoriteItems');

    if (favoriteItemsString != null) {
      _favoriteItems = favoriteItemsString.map((itemString) {
        final Map<String, dynamic> itemMap = json.decode(itemString);
        return MenuItem(
          name: itemMap['name'],
          price: itemMap['price'],
          isFavorite: itemMap['isFavorite'] ?? false,
        );
      }).toList();
      notifyListeners();
    }
  }

  void _saveFavoriteItems() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteItemsString = _favoriteItems.map((item) {
      return json.encode({
        'name': item.name,
        'price': item.price,
        'isFavorite': item.isFavorite,
      });
    }).toList();
    prefs.setStringList('favoriteItems', favoriteItemsString);
  }

  bool isFavorite(MenuItem item) {
    return _favoriteItems.any((favItem) => favItem.name == item.name && favItem.price == item.price);
  }

  void toggleFavorite(MenuItem item) {
    if (isFavorite(item)) {
      _favoriteItems.removeWhere((favItem) => favItem.name == item.name && favItem.price == item.price);
      item.isFavorite = false;
    } else {
      item.isFavorite = true;
      _favoriteItems.add(item);
    }
    _saveFavoriteItems();
    notifyListeners();
  }
}
