import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white), // For back button color
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
        child: Center(
          child: Text(
            'No new notifications',
            style: TextStyle(fontSize: 24, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
