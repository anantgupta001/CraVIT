import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_home_app/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black87 : Colors.white, // Adjust background based on theme
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.black : Colors.white, // Adjust app bar based on theme
        foregroundColor: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black, // Adjust text color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 18,
                    color: themeProvider.themeMode == ThemeMode.dark ? Colors.white : Colors.black,
                  ),
                ),
                Switch(
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
