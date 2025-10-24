import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:cravit/theme_provider.dart'; // Import ThemeProvider

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust background based on theme
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // Adjust title color
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust app bar background
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black), // For back button color
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
        child: Center(
          child: Text(
            'No new notifications',
            style: TextStyle(fontSize: 24, color: isDarkMode ? Colors.white70 : Colors.black54), // Adjust text color
          ),
        ),
      ),
    );
  }
}
