import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_home_app/mess_menu_page.dart';
import 'package:my_home_app/notification_page.dart'; // Import the new notification_page.dart
import 'package:my_home_app/cart_page.dart'; // Import the new cart_page.dart
import 'package:my_home_app/profile_page.dart';
import 'package:my_home_app/favorite_food_page.dart'; // Import the new favorite_food_page.dart
import 'package:my_home_app/shop_page.dart'; // Import the new shop_page.dart

class HomePage extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const HomePage({super.key, required this.googleSignIn});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userName;
  int _selectedIndex = 0; // New: To keep track of the selected tab

  // New: List of pages to display in the BottomNavigationBar
  late final List<Widget> _widgetOptions; 

  @override
  void initState() {
    super.initState();
    _getUserName();
    _widgetOptions = <Widget>[
      _buildHomeContent(), // 0: Home
      const MessMenuPage(), // 1: Mess Menu
      Builder(builder: (context) => const CartPage()), // 2: Cart - Wrapped with Builder
      const NotificationPage(), // 3: Notifications - Index shifted
      const FavoriteFoodPage(), // 4: Favorite Food
    ];
  }

  void _getUserName() {
    if (widget.googleSignIn.currentUser != null) {
      setState(() {
        _userName = widget.googleSignIn.currentUser!.displayName;
      });
    }
  }

  Widget _buildHomeContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center( // Wrap the Text widget with Center
          child: Text(
            'Greeting ${_userName ?? 'User'}!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _onItemTapped(4); // Use _onItemTapped for consistency
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[800],
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          child: const Text('Favorite Food', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ShopPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber[800],
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          child: const Text('Shop', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          _selectedIndex == 0 ? 'Home' :
          _selectedIndex == 1 ? 'Mess Menu' :
          _selectedIndex == 2 ? 'Cart' : // New index for Cart
          _selectedIndex == 3 ? 'Notifications' : // New index for Notifications
          'Favorite Food', // Remains index 4
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.blueGrey[400],
              child: const Icon(Icons.person, color: Colors.white70),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProfilePage(googleSignIn: widget.googleSignIn)),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[800],
        onPressed: () {
          setState(() {
            _selectedIndex = 2; // Navigate to Cart page
          });
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.shopping_cart, color: Colors.white, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.amber[800] : Colors.white),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.restaurant_menu, color: _selectedIndex == 1 ? Colors.amber[800] : Colors.white),
              onPressed: () => _onItemTapped(1),
            ),
            const SizedBox(width: 48), // The space for the FloatingActionButton
            IconButton(
              icon: Icon(Icons.notifications, color: _selectedIndex == 3 ? Colors.amber[800] : Colors.white),
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: _selectedIndex == 4 ? Colors.amber[800] : Colors.white),
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
