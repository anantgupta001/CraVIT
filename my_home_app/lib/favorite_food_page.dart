import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:cravit/theme_provider.dart'; // Import ThemeProvider
import 'package:cravit/favorite_provider.dart'; // Import FavoriteProvider
import 'package:cravit/shop_page.dart'; // Import MenuItem

class FavoriteFoodPage extends StatefulWidget {
  const FavoriteFoodPage({super.key});

  @override
  State<FavoriteFoodPage> createState() => _FavoriteFoodPageState();
}

class _FavoriteFoodPageState extends State<FavoriteFoodPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFavorites);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFavorites);
    _searchController.dispose();
    super.dispose();
  }

  void _filterFavorites() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust background based on theme
      appBar: AppBar(
        title: Text('Favorite Foods', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // Adjust title color
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust app bar background
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black), // For back button color
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight), // Height of the search bar
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search favorite foods...',
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                filled: true,
                fillColor: isDarkMode ? Colors.blueGrey[700] : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              ),
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          final filteredFavoriteItems = favoriteProvider.favoriteItems.where((item) {
            return item.name.toLowerCase().contains(_searchQuery.toLowerCase());
          }).toList();

          if (filteredFavoriteItems.isEmpty) {
            return Center(
              child: Text(
                _searchQuery.isEmpty ? 'No favorite foods yet!' : 'No matching favorite foods found.',
                style: TextStyle(fontSize: 24, color: isDarkMode ? Colors.white70 : Colors.black54),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: filteredFavoriteItems.length,
              itemBuilder: (context, index) {
                final MenuItem item = filteredFavoriteItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  color: isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey[100],
                  child: ListTile(
                    title: Text(item.name, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
                    subtitle: Text('\$${item.price.toStringAsFixed(2)}', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54)),
                    trailing: IconButton(
                      icon: Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        favoriteProvider.toggleFavorite(item);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
