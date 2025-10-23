import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cravit/theme_provider.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
      appBar: AppBar(
        title: Text(
          'About craVIT',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🍔 About craVIT',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to craVIT — your one-stop food-ordering app for everything inside VIT-AP campus!',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'craVIT is built to make your food experience on campus fast, easy, and hassle-free. Whether you’re craving a quick snack, a refreshing drink, or a proper meal, you can browse all VIT-AP food stores in one place and order directly from your phone.',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This app is created and developed by Anant Gupta, with the aim of bringing all campus food outlets together on a single digital platform.',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'With craVIT, you can:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildFeatureItem('🍕 Explore all food stores inside VIT-AP', isDarkMode),
            _buildFeatureItem('🛒 Order and pay online securely', isDarkMode),
            _buildFeatureItem('🚶 Pick up your order or get it delivered to your hostel (if available)', isDarkMode),
            _buildFeatureItem('💬 Stay updated with real-time order status', isDarkMode),
            const SizedBox(height: 24),
            Text(
              'craVIT is not an official VIT app — it’s an independent project made by a student for students, staff, and visitors who love food from the VIT-AP campus!',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'For any feedback, suggestions, or support, you can always reach out at 📧 anantagarwal4946@gmail.com',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.white70 : Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, size: 20, color: isDarkMode ? Colors.greenAccent : Colors.green[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white : Colors.black87, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
