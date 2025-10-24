import 'package:flutter/material.dart';
import 'package:seller_app/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _orderAlertSound = true;
  String? _subscribedTopic;

  @override
  void initState() {
    super.initState();
    _getSubscribedTopic();
  }

  Future<void> _getSubscribedTopic() async {
    // In a real app, you might fetch this from user preferences or a backend.
    // For this example, we'll use the constant topic.
    setState(() {
      _subscribedTopic = 'vendor_$activeVendorId';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Firebase Messaging Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListTile(
          title: const Text('Subscribed Topic'),
          subtitle: Text(_subscribedTopic ?? 'N/A'),
        ),
        SwitchListTile(
          title: const Text('Order alert sound'),
          value: _orderAlertSound,
          onChanged: (bool value) {
            setState(() {
              _orderAlertSound = value;
              // TODO: Implement actual sound toggle logic
              if (kDebugMode) {
                print('Order alert sound toggled to: $value');
              }
            });
          },
        ),
        const Divider(),
        // Add other settings here
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'General Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const ListTile(
          title: Text('App Version'),
          subtitle: Text('1.0.0'), // Placeholder
        ),
      ],
    );
  }
}
