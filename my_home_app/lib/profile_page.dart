import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cravit/main.dart';
import 'package:cravit/cart_page.dart'; // Import the cart_page.dart
import 'package:cravit/favorite_food_page.dart'; // Import the favorite_food_page.dart
import 'package:cravit/notification_page.dart'; // Import the notification_page.dart
import 'package:cravit/settings_page.dart'; // Import the new settings_page.dart
import 'package:cravit/personal_information_page.dart'; // Import the new personal_information_page.dart
import 'package:provider/provider.dart'; // Import provider
import 'package:cravit/theme_provider.dart'; // Import ThemeProvider
import 'package:cravit/faq_page.dart'; // Import FaqPage
import 'package:cravit/about_page.dart'; // Import AboutPage

class ProfilePage extends StatefulWidget {
  final GoogleSignIn googleSignIn;
  final String? userEmail;
  final String? userName;
  final String? userPhotoUrl; // Add userPhotoUrl parameter

  const ProfilePage({super.key, required this.googleSignIn, this.userEmail, this.userName, this.userPhotoUrl}); // Update constructor

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _userName = widget.userName; // Initialize from widget.userName
    // _getUserName(); // No longer needed as userName is passed
  }

  // Removed _getUserName method
  // void _getUserName() {
  //   if (widget.googleSignIn.currentUser != null) {
  //     setState(() {
  //       _userName = widget.googleSignIn.currentUser!.displayName;
  //     });
  //   }
  // }

  Future<void> _handleSignOut() async {
    try {
      await widget.googleSignIn.signOut();
      print('Signed out from Google (from Profile Page)');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(title: 'Sign in to your account')),
      );
    } catch (error) {
      print('Error signing out from Google (from Profile Page): $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust background based on theme
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // Adjust title color
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust app bar background
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black), // For back button color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: isDarkMode ? Colors.blueGrey[700] : Colors.blueGrey[400], // Adjust based on theme
                    backgroundImage: widget.userPhotoUrl != null ? NetworkImage(widget.userPhotoUrl!) : null, // Use NetworkImage if photoUrl is available
                    child: widget.userPhotoUrl == null ? Icon(Icons.person, size: 50, color: isDarkMode ? Colors.white70 : Colors.black54) : null, // Placeholder icon
                  ),
                  SizedBox(width: 16),
                  Text(
                    _userName ?? 'User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black), // Adjust based on theme
                  ),
                ],
              ),
            ),
            _buildSection(
              context,
              [
                _buildListItem(context, Icons.person, 'Personal Info', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PersonalInformationPage(fullName: _userName ?? '', email: widget.userEmail ?? '', photoUrl: widget.userPhotoUrl)),
                  );
                }, iconColor: isDarkMode ? Colors.white : Colors.black54, textColor: isDarkMode ? Colors.white : Colors.black),
              ],
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              [
                _buildListItem(context, Icons.shopping_cart, 'Cart', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartPage()),
                  );
                }, iconColor: isDarkMode ? Colors.white : Colors.black54, textColor: isDarkMode ? Colors.white : Colors.black),
                _buildListItem(context, Icons.favorite, 'Favourite', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => FavoriteFoodPage()),
                  );
                }, iconColor: isDarkMode ? Colors.white : Colors.black54, textColor: isDarkMode ? Colors.white : Colors.black),
                _buildListItem(context, Icons.notifications, 'Notifications', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                }, iconColor: isDarkMode ? Colors.white : Colors.black54, textColor: isDarkMode ? Colors.white : Colors.black),
              ],
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              [
                _buildListItem(context, Icons.help, 'FAQs', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const FaqPage()),
                  );
                }, iconColor: isDarkMode ? Colors.white : Colors.black54, textColor: isDarkMode ? Colors.white : Colors.black),
                _buildListItem(context, Icons.info, 'About', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                }, iconColor: isDarkMode ? Colors.white : Colors.black54, textColor: isDarkMode ? Colors.white : Colors.black),
                _buildListItem(context, Icons.settings, 'Settings', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                }, iconColor: isDarkMode ? Colors.white : Colors.black54, textColor: isDarkMode ? Colors.white : Colors.black),
              ],
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              [
                _buildListItem(context, Icons.logout, 'Log Out', _handleSignOut, iconColor: Colors.red, textColor: isDarkMode ? Colors.white : Colors.black),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, List<Widget> children) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      color: isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey[100], // Adjust card color based on theme
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color iconColor = Colors.white, Color textColor = Colors.white}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: textColor), // Use textColor parameter
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: isDarkMode ? Colors.white54 : Colors.black54, size: 16), // Adjust based on theme
          ],
        ),
      ),
    );
  }
}
