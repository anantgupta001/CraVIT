import 'package:flutter/material.dart';

class FavoriteFoodPage extends StatelessWidget {
  const FavoriteFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Your Favorite Foods',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
