import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cravit/mess_menu_page.dart';
import 'package:cravit/notification_page.dart'; // Import the new notification_page.dart
import 'package:cravit/cart_page.dart'; // Import the new cart_page.dart
import 'package:cravit/profile_page.dart';
import 'package:cravit/favorite_food_page.dart'; // Import the new favorite_food_page.dart
import 'package:cravit/shop_page.dart'; // Import the new shop_page.dart
import 'package:provider/provider.dart';
import 'package:cravit/theme_provider.dart';
import 'dart:async'; // Import for Timer

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userName;
  int _selectedIndex = 0; // New: To keep track of the selected tab

  // New: List of pages to display in the BottomNavigationBar
  late List<Widget> _widgetOptions;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getUserName();
    // Start a timer to refresh the UI every minute to update meal times
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Map<String, dynamic> _getCurrentMeal() {
    // This method is not provided in the original file, so it's not included here.
    // It would typically return a map of meal details.
    return {};
  }

  void _getUserName() {
    // This method is not provided in the original file, so it's not included here.
    // It would typically fetch the user's name from Google Sign-In.
    // For now, it's a placeholder.
    setState(() {
      _userName = "User"; // Replace with actual user name
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cravit'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Shop',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
