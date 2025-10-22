import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:my_home_app/theme_provider.dart'; // Import ThemeProvider

class FavoriteFoodPage extends StatelessWidget {
  const FavoriteFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust background based on theme
      appBar: AppBar(
        title: Text('Favorite Foods', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // Adjust title color
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust app bar background
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black), // For back button color
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
        child: Center(
          child: Text(
            'Your Favorite Foods',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black), // Adjust text color
          ),
        ),
      ),
    );
  }
}
