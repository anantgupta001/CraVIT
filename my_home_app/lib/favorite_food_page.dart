import 'package:flutter/material.dart';

class FavoriteFoodPage extends StatelessWidget {
  const FavoriteFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Consistent background color
      appBar: AppBar(
        title: const Text('Favorite Foods', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white), // For back button color
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
        child: Center(
          child: Text(
            'Your Favorite Foods',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
