import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cravit/theme_provider.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final List<Map<String, String>> faqs = [
      {
        'question': '1️⃣ What is craVIT?',
        'answer':
            'craVIT is a food-ordering app made for people who want to order food from VIT-AP campus food stores easily and quickly.',
      },
      {
        'question': '2️⃣ Who created craVIT?',
        'answer':
            'craVIT is developed by Anant Gupta, with the goal of making food ordering within VIT-AP smoother and more convenient.',
      },
      {
        'question': '3️⃣ Who can use craVIT?',
        'answer':
            'Anyone can use craVIT! You don’t need to be a VIT student — just sign up and start ordering your favorite food from VIT-AP’s food outlets.',
      },
      {
        'question': '4️⃣ How do I place an order?',
        'answer':
            'Simply browse through the available food items → add what you want to the cart → confirm your order → pay online. You’ll get notified once your order is accepted.',
      },
      {
        'question': '5️⃣ Is online payment available?',
        'answer':
            '✅ Yes! craVIT supports online payments for a smooth and secure ordering experience.',
      },
      {
        'question': '6️⃣ Can I cancel my order?',
        'answer':
            'You can cancel your order before it’s accepted by the vendor. Once the food is being prepared, cancellations aren’t allowed.',
      },
      {
        'question': '7️⃣ Where will I receive my order?',
        'answer':
            'You can choose pickup from the store or hostel delivery, depending on what the vendor offers.',
      },
      {
        'question': '8️⃣ How can food vendors join craVIT?',
        'answer':
            'Food stores or vendors inside the VIT-AP campus can register through the vendor section and start listing their menu after approval.',
      },
      {
        'question': '9️⃣ Is craVIT an official VIT app?',
        'answer':
            'No, craVIT is not an official VIT app. It’s an independent project created by Anant Gupta to help people order food easily on campus.',
      },
      {
        'question': '🔟 How can I contact support?',
        'answer':
            'For any queries, suggestions, or issues, feel free to mail us at 📩 anantagarwal4946@gmail.com',
      },
    ];

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
      appBar: AppBar(
        title: Text(
          'FAQs',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return Card(
            color: isDarkMode ? Colors.blueGrey[800] : Colors.blueGrey[50],
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    faqs[index]['question']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    faqs[index]['answer']!,
                    style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87, fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
