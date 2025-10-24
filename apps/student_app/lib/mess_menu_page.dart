import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:cravit/theme_provider.dart'; // Import ThemeProvider
import 'dart:convert'; // Import for JSON decoding
import 'package:flutter/services.dart' show rootBundle; // Import for loading assets

// Data class for a single mess menu item
class MessDayMenu {
  final String dayAndDates;
  final List<String> breakfast;
  final List<String> lunch;
  final List<String> snacks;
  final List<String> dinner;
  final DateTime parsedDate; // Add this field

  MessDayMenu({
    required this.dayAndDates,
    required this.breakfast,
    required this.lunch,
    required this.snacks,
    required this.dinner,
    required this.parsedDate, // And this to the constructor
  });

  List<String> getMealItems(String mealName) {
    switch (mealName) {
      case 'Breakfast':
        return breakfast;
      case 'Lunch':
        return lunch;
      case 'Snacks':
        return snacks;
      case 'Dinner':
        return dinner;
      default:
        return [];
    }
  }
}

class MessMenuPage extends StatelessWidget {
  const MessMenuPage({super.key});

  static Future<List<MessDayMenu>> _loadMessMenuData() async {
    final String response = await rootBundle.loadString('assets/mess_menu.json');
    final List<dynamic> data = json.decode(response);
    final now = DateTime.now();

    return data.map((item) {
      final datePattern = RegExp(r'\d+');
      final matches = datePattern.allMatches(item['dayAndDates'] as String);
      int? day1, day2;

      if (matches.isNotEmpty) {
        day1 = int.tryParse(matches.first.group(0)!);
        if (matches.length > 1) {
          day2 = int.tryParse(matches.last.group(0)!);
        }
      }

      // Determine which date is closer to today, or if today's date exists
      DateTime date;
      if (day1 != null && day2 != null) {
        final date1 = DateTime(now.year, now.month, day1);
        final date2 = DateTime(now.year, now.month, day2);

        // If today's day matches either, use that
        if (now.day == day1) {
          date = date1;
        } else if (now.day == day2) {
          date = date2;
        }
        // If one of the dates is in the future, prefer it
        else if (date1.isAfter(now) && date2.isAfter(now)) {
          date = date1.isBefore(date2) ? date1 : date2;
        } else if (date1.isAfter(now)) {
          date = date1;
        } else if (date2.isAfter(now)) {
          date = date2;
        }
        // Otherwise, pick the one closest to today (arbitrarily pick day1 if both are in the past)
        else {
          date = date1;
        }
      } else if (day1 != null) {
        date = DateTime(now.year, now.month, day1);
      } else {
        // Fallback to a default date or handle error
        date = DateTime(now.year, now.month, now.day);
      }

      return MessDayMenu(
        dayAndDates: item['dayAndDates'] as String,
        breakfast: List<String>.from(item['breakfast'] as List<dynamic>),
        lunch: List<String>.from(item['lunch'] as List<dynamic>),
        snacks: List<String>.from(item['snacks'] as List<dynamic>),
        dinner: List<String>.from(item['dinner'] as List<dynamic>),
        parsedDate: date, // Assign the parsed date
      );
    }).toList();
  }

  static Future<MessDayMenu?> getMenuForDate(DateTime date) async {
    final List<MessDayMenu> fullMenu = await _loadMessMenuData();

    for (var dayMenu in fullMenu) {
      final datePattern = RegExp(r'\d+'); // Regex to find numbers (dates) in the string
      final matches = datePattern.allMatches(dayMenu.dayAndDates);

      // Assuming the last number in dayAndDates is the day of the month
      if (matches.isNotEmpty) {
        final dayString = matches.last.group(0)!;
        final day = int.tryParse(dayString);
        
        // Extract month and year from dayAndDates (e.g., "Mon 13,27" -> 13 or 27)
        // This part needs to be more robust if the month/year is not static or if dayAndDates format changes.
        // For now, we will assume the current month and year for simplicity as it was hardcoded in the original JSON.
        // In a real app, this would come from a dynamic source or a clearer JSON field.
        final menuDate = DateTime(date.year, date.month, day!);

        if (date.year == menuDate.year && date.month == menuDate.month && date.day == menuDate.day) {
          return dayMenu;
        }
      }
    }
    return null; // Menu for the given date not found
  }

  // No longer needed: _getCurrentYearAndMonth and _parseMessMenu are removed.

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust background based on theme
      appBar: AppBar(
        title: Text('Mess Menu', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)), // Adjust title color
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white, // Adjust app bar background
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black), // For back button color
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Added horizontal padding
        child: FutureBuilder<List<MessDayMenu>>(
          future: _loadMessMenuData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No mess menu available.'));
            } else {
              List<MessDayMenu> messMenu = snapshot.data!;
              messMenu.sort((a, b) {
                final today = DateTime.now();
                final todayWithoutTime = DateTime(today.year, today.month, today.day);

                // Function to determine the "sort value" of a date
                // Closer to today (or today itself) gets a lower value
                int getDateSortValue(DateTime date) {
                  final dateWithoutTime = DateTime(date.year, date.month, date.day);
                  if (dateWithoutTime.isAtSameMomentAs(todayWithoutTime)) {
                    return 0; // Today's menu is highest priority
                  } else if (dateWithoutTime.isAfter(todayWithoutTime)) {
                    return dateWithoutTime.difference(todayWithoutTime).inDays; // Future dates by difference
                  } else {
                    return 1000 + todayWithoutTime.difference(dateWithoutTime).inDays; // Past dates lower priority, offset by a large number
                  }
                }

                final sortValueA = getDateSortValue(a.parsedDate);
                final sortValueB = getDateSortValue(b.parsedDate);

                return sortValueA.compareTo(sortValueB);
              });
              return ListView.builder(
                itemCount: messMenu.length,
                itemBuilder: (context, index) {
                  MessDayMenu dayMenu = messMenu[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    color: isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey[100], // Adjust card color based on theme
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dayMenu.dayAndDates,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black), // Adjust based on theme
                          ),
                          Divider(color: isDarkMode ? Colors.white70 : Colors.black38), // Adjust divider color
                          _buildMealSection('Breakfast', dayMenu.breakfast, isDarkMode),
                          _buildMealSection('Lunch', dayMenu.lunch, isDarkMode),
                          _buildMealSection('Snacks', dayMenu.snacks, isDarkMode),
                          _buildMealSection('Dinner', dayMenu.dinner, isDarkMode),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMealSection(String title, List<String> items, bool isDarkMode) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white70 : Colors.black54), // Adjust based on theme
          ),
          const SizedBox(height: 4),
          ...
              items.map((item) => Text('- $item', style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black45), softWrap: true)).toList(), // Adjust based on theme
        ],
      ),
    );
  }
}
