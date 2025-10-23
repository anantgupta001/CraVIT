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
  final GoogleSignIn googleSignIn;
  final String? userEmail;
  final String? userName; // Add userName parameter
  final String? userPhotoUrl; // Add userPhotoUrl parameter

  const HomePage({super.key, required this.googleSignIn, this.userEmail, this.userName, this.userPhotoUrl}); // Update constructor

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userName; // Keep _userName for greeting, but will be initialized from widget.userName
  int _selectedIndex = 0; // New: To keep track of the selected tab

  // New: List of pages to display in the BottomNavigationBar
  late List<Widget> _widgetOptions;

  Timer? _timer; // Declare the Timer

  @override
  void initState() {
    super.initState();
    _userName = widget.userName; // Initialize from widget.userName
    // _getUserName(); // No longer needed as userName is passed
    // Start a timer to refresh the UI every minute to update meal times
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<Map<String, dynamic>> _getCurrentMeal() async {
    final now = DateTime.now();
    final currentTime = TimeOfDay.fromDateTime(now);

    final todayMenu = await MessMenuPage.getMenuForDate(now);
    final tomorrowMenu = await MessMenuPage.getMenuForDate(now.add(const Duration(days: 1)));

    final List<Map<String, dynamic>> allMealsWithTimes = [];

    // Add today's meals
    if (todayMenu != null) {
      _addMealsToList(allMealsWithTimes, todayMenu, now);
    }

    // Add tomorrow's meals
    if (tomorrowMenu != null) {
      _addMealsToList(allMealsWithTimes, tomorrowMenu, now.add(const Duration(days: 1)));
    }

    // Sort all meals by their start time
    allMealsWithTimes.sort((a, b) => (a['mealStartDateTime'] as DateTime).compareTo(b['mealStartDateTime'] as DateTime));

    // Find current or upcoming meal
    for (var mealEntry in allMealsWithTimes) {
      final mealStartDateTime = mealEntry['mealStartDateTime'] as DateTime;
      final mealEndDateTime = mealEntry['mealEndDateTime'] as DateTime;

      if (now.isAfter(mealStartDateTime) && now.isBefore(mealEndDateTime)) {
        return {'name': mealEntry['name'], 'items': mealEntry['items'], 'type': 'current'};
      } else if (now.isBefore(mealStartDateTime)) {
        return {'name': mealEntry['name'], 'items': mealEntry['items'], 'type': 'upcoming'};
      }
    }

    return {'name': 'No upcoming meal', 'items': [], 'type': 'none'};
  }

  // Helper function to add meals with their absolute DateTimes to a list
  void _addMealsToList(List<Map<String, dynamic>> list, MessDayMenu menu, DateTime date) {
    const mealTimes = {
      'Breakfast': {'startHour': 7, 'startMinute': 0, 'endHour': 9, 'endMinute': 0},
      'Lunch': {'startHour': 12, 'startMinute': 0, 'endHour': 15, 'endMinute': 0},
      'Snacks': {'startHour': 17, 'startMinute': 30, 'endMinute': 30, 'endHour': 18},
      'Dinner': {'startHour': 19, 'startMinute': 0, 'endHour': 21, 'endMinute': 0},
    };

    mealTimes.forEach((mealName, times) {
      final startTime = DateTime(date.year, date.month, date.day, times['startHour']!, times['startMinute']!);
      final endTime = DateTime(date.year, date.month, date.day, times['endHour']!, times['endMinute']!);

      list.add({
        'name': mealName,
        'items': menu.getMealItems(mealName),
        'mealStartDateTime': startTime,
        'mealEndDateTime': endTime,
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void _getUserName() {
    if (widget.googleSignIn.currentUser != null) {
      setState(() {
        _userName = widget.googleSignIn.currentUser!.displayName;
      });
    }
  }

  Widget _buildHomeContent(bool isDarkMode) {
    const int _maxMealItemsToShow = 4; // Max items to show in the meal box

    return FutureBuilder<Map<String, dynamic>>(
      future: _getCurrentMeal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!['type'] == 'none') {
          // Display a message if no current or upcoming meal is found
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'No meal data available',
                  style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              // Optionally, display a placeholder or hide the box entirely
              Container(),
            ],
          );
        } else {
          final currentMeal = snapshot.data!;
          return SingleChildScrollView( // Wrap the Column in SingleChildScrollView
            child: Column( // Changed from SingleChildScrollView
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0), // Horizontal padding for the text
                  child: Text(
                    currentMeal['type'] == 'current' ? 'Current Meal' : 'Upcoming Meal',
                    style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)), // Adjust based on theme
                ),
                const SizedBox(height: 10), // Space between text and container
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 10.0), // Original horizontal, no top padding, original bottom padding
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => MessMenuPage()),
                      );
                    },
                    child: Container(
                      width: double.infinity, // Ensure width matches external padding
                      height: 250, // Fixed height for the meal box
                      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0), // Increased internal vertical padding
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey[100], // Adjust based on theme
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: isDarkMode ? Colors.blueAccent : Colors.lightBlue, width: 2), // Adjust based on theme
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentMeal['name'], style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 36, fontWeight: FontWeight.bold)), // Adjust based on theme
                          const SizedBox(height: 8),
                          Expanded( // Use Expanded to constrain the list of items
                            child: SingleChildScrollView( // Allow scrolling if items overflow
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: (
                                  currentMeal['items'] as List<String>)
                                  .map((item) => Text(item, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 20)))
                                  .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                        IconButton(
                          icon: Icon(Icons.store, color: isDarkMode ? Colors.white : Colors.black, size: 50), // Adjust based on theme
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ShopPage()), // All Shops
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.restaurant, color: isDarkMode ? Colors.white : Colors.black, size: 50), // Adjust based on theme
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ShopPage(shopCategory: 'Restaurant')),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.local_cafe, color: isDarkMode ? Colors.white : Colors.black, size: 50), // Adjust based on theme
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ShopPage(shopCategory: 'Cafe')),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.shopping_bag, color: isDarkMode ? Colors.white : Colors.black, size: 50), // Adjust based on theme
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ShopPage(shopCategory: 'Desserts')),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.fastfood, color: isDarkMode ? Colors.white : Colors.black, size: 50), // Adjust based on theme
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ShopPage(shopCategory: 'Fast Food')),
                            );
                          },
                        ),
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: IconButton(
                            icon: Icon(Icons.apps, color: isDarkMode ? Colors.white : Colors.black, size: 50), // Adjust based on theme
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ShopPage()), // All Shops (or a dedicated 'More' page)
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    _widgetOptions = <Widget>[
      _buildHomeContent(isDarkMode), // Only Home content in the main body
    ];

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
                    backgroundImage: widget.userPhotoUrl != null ? NetworkImage(widget.userPhotoUrl!) : null, // Use NetworkImage if photoUrl is available
                    child: widget.userPhotoUrl == null ? Icon(Icons.person, color: isDarkMode ? Colors.white70 : Colors.black54) : null, // Adjust based on theme
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilePage(googleSignIn: widget.googleSignIn, userEmail: widget.userEmail, userName: _userName, userPhotoUrl: widget.userPhotoUrl)), // Pass userPhotoUrl
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
            MaterialPageRoute(builder: (context) => CartPage()), // Changed to CartPage
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
                  MaterialPageRoute(builder: (context) => MessMenuPage()),
                );
              },
            ),
            const SizedBox(width: 48), // The space for the FloatingActionButton
            IconButton(
              icon: Icon(Icons.favorite, color: isDarkMode ? Colors.white : Colors.black54), // Adjust based on theme
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FavoriteFoodPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications, color: isDarkMode ? Colors.white : Colors.black54), // Adjust based on theme
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => NotificationPage()),
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
