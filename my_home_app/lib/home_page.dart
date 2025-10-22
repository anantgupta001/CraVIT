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
      _buildHomeContent(), // Only Home content in the main body
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
    return Column( // Changed from SingleChildScrollView
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding for the text
            child: const Text('Upcoming meal', style: TextStyle(color: Colors.white70, fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10), // Space between text and container
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0), // Original horizontal, no top padding, original bottom padding
            child: Container(
              width: double.infinity, // Ensure width matches external padding
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0), // Increased internal vertical padding
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Breakfast', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)), // Increased font size
                  const SizedBox(height: 8),
                  const Text('Aloo Paratha', style: TextStyle(color: Colors.white, fontSize: 20)), // Increased font size
                  const SizedBox(height: 4),
                  const Text('Chutney', style: TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 4),
                  const Text('Dahi', style: TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 4),
                  const Text('Egg', style: TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 60), // Space after Upcoming meal and before Greetings User!
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0), // Reduced left padding for Greetings User!
            child: Text(
              'Greetings ${_userName ?? 'User'} !',
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 30), // Adjusted space between Greetings User! and All Shops grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Reduced vertical padding for All Shops container
            child: Container(
              padding: const EdgeInsets.all(16.0), // Reduced internal padding
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.amber, width: 2),
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3, // Changed to 3 columns for 2x3 grid
                mainAxisSpacing: 25.0, // Spacing between rows
                crossAxisSpacing: 25.0, // Spacing between columns
                children: <Widget>[
                  SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.store, color: Colors.white, size: 50))), // Wrapped in SizedBox
                  SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.restaurant, color: Colors.white, size: 50))), // Wrapped in SizedBox
                  SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.local_cafe, color: Colors.white, size: 50))), // Wrapped in SizedBox
                  SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.shopping_bag, color: Colors.white, size: 50))), // Wrapped in SizedBox
                  SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.fastfood, color: Colors.white, size: 50))), // Wrapped in SizedBox
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: IconButton(
                      icon: const Icon(Icons.apps, color: Colors.white, size: 50),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const ShopPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: null, // Remove the AppBar
      body: Column(
        children: [
          const SizedBox(height: 50), // Added space to shift profile icon down
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align the profile icon to the right
              children: [
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
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
              child: _widgetOptions.elementAt(0), // Always show _buildHomeContent
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber[800],
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CartPage()), // Changed to CartPage
          ); // Navigate to Cart page using FloatingActionButton
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.shopping_cart, color: Colors.white, size: 30), // Changed to shopping_cart icon
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
              icon: const Icon(Icons.home, color: Colors.amber),
              onPressed: () {
                // Already on home, no action needed or refresh current page
              },
            ),
            IconButton(
              icon: const Icon(Icons.apartment, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MessMenuPage()),
                );
              },
            ),
            const SizedBox(width: 48), // The space for the FloatingActionButton
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const FavoriteFoodPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Remove _onItemTapped as direct navigation is used for bottom nav bar
}
