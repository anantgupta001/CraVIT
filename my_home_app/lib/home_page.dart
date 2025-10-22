import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_home_app/mess_menu_page.dart';
import 'package:my_home_app/notification_page.dart'; // Import the new notification_page.dart
import 'package:my_home_app/cart_page.dart'; // Import the new cart_page.dart
import 'package:my_home_app/profile_page.dart';
import 'package:my_home_app/favorite_food_page.dart'; // Import the new favorite_food_page.dart
import 'package:my_home_app/shop_page.dart'; // Import the new shop_page.dart
import 'package:provider/provider.dart';
import 'package:my_home_app/theme_provider.dart';

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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Column( // Changed from SingleChildScrollView
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding for the text
            child: Text('Upcoming meal', style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)), // Adjust based on theme
          ),
          const SizedBox(height: 10), // Space between text and container
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0), // Original horizontal, no top padding, original bottom padding
            child: Container(
              width: double.infinity, // Ensure width matches external padding
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0), // Increased internal vertical padding
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey[100], // Adjust based on theme
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: isDarkMode ? Colors.blueAccent : Colors.lightBlue, width: 2), // Adjust based on theme
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Breakfast', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 36, fontWeight: FontWeight.bold)), // Adjust based on theme
                  const SizedBox(height: 8),
                  Text('Aloo Paratha', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 20)), // Adjust based on theme
                  const SizedBox(height: 4),
                  Text('Chutney', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 20)), // Adjust based on theme
                  const SizedBox(height: 4),
                  Text('Dahi', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 20)), // Adjust based on theme
                  const SizedBox(height: 4),
                  Text('Egg', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 20)), // Adjust based on theme
                ],
              ),
            ),
          ),
          const SizedBox(height: 60), // Space after Upcoming meal and before Greetings User!
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0), // Reduced left padding for Greetings User!
            child: Text(
              'Greetings ${_userName ?? 'User'} !',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black), // Adjust based on theme
            ),
          ),
          const SizedBox(height: 30), // Adjusted space between Greetings User! and All Shops grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), // Reduced vertical padding for All Shops container
            child: Container(
              padding: const EdgeInsets.all(16.0), // Reduced internal padding
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey[100], // Adjust based on theme
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: isDarkMode ? Colors.amber : Colors.deepOrange, width: 2), // Adjust based on theme
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3, // Changed to 3 columns for 2x3 grid
                mainAxisSpacing: 25.0, // Spacing between rows
                crossAxisSpacing: 25.0, // Spacing between columns
                children: <Widget>[
                  SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.store, color: isDarkMode ? Colors.white : Colors.black, size: 50))), // Adjust based on theme
                  SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.restaurant, color: isDarkMode ? Colors.white : Colors.black, size: 50))), // Adjust based on theme
                  SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.local_cafe, color: isDarkMode ? Colors.white : Colors.black, size: 50))), // Adjust based on theme
                  SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.shopping_bag, color: isDarkMode ? Colors.white : Colors.black, size: 50))), // Adjust based on theme
                  SizedBox(width: 100, height: 100, child: Center(child: Icon(Icons.fastfood, color: isDarkMode ? Colors.white : Colors.black, size: 50))), // Adjust based on theme
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: IconButton(
                      icon: Icon(Icons.apps, color: isDarkMode ? Colors.white : Colors.black, size: 50), // Adjust based on theme
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Dark background for dark mode, white for light mode
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
                    backgroundColor: isDarkMode ? Colors.blueGrey[700] : Colors.blueGrey[400], // Adjust based on theme
                    child: Icon(Icons.person, color: isDarkMode ? Colors.white70 : Colors.black54), // Adjust based on theme
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
        backgroundColor: isDarkMode ? Colors.orange[800] : Colors.amber[800], // Adjust based on theme
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CartPage()), // Changed to CartPage
          ); // Navigate to Cart page using FloatingActionButton
        },
        shape: const CircleBorder(),
        child: const Icon(Icons.shopping_cart, color: Colors.white, size: 30), // Consistent white icon
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: isDarkMode ? Colors.black : Colors.blueGrey[50], // Adjust based on theme
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home, color: isDarkMode ? Colors.amber : Colors.deepOrange), // Adjust based on theme
              onPressed: () {
                // Already on home, no action needed or refresh current page
              },
            ),
            IconButton(
              icon: Icon(Icons.apartment, color: isDarkMode ? Colors.white : Colors.black54), // Adjust based on theme
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MessMenuPage()),
                );
              },
            ),
            const SizedBox(width: 48), // The space for the FloatingActionButton
            IconButton(
              icon: Icon(Icons.favorite, color: isDarkMode ? Colors.white : Colors.black54), // Adjust based on theme
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const FavoriteFoodPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: isDarkMode ? Colors.white : Colors.black54), // Adjust based on theme
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
