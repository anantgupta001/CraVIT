import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_home_app/main.dart';

class ProfilePage extends StatefulWidget {
  final GoogleSignIn googleSignIn;

  const ProfilePage({super.key, required this.googleSignIn});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  void _getUserName() {
    if (widget.googleSignIn.currentUser != null) {
      setState(() {
        _userName = widget.googleSignIn.currentUser!.displayName;
      });
    }
  }

  Future<void> _handleSignOut() async {
    try {
      await widget.googleSignIn.signOut();
      print('Signed out from Google (from Profile Page)');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Sign in to your account')),
      );
    } catch (error) {
      print('Error signing out from Google (from Profile Page): $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white), // For back button color
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
                    backgroundColor: Colors.blueGrey[400],
                    child: Icon(Icons.person, size: 50, color: Colors.white70), // Placeholder icon
                  ),
                  SizedBox(width: 16),
                  Text(
                    _userName ?? 'User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            _buildSection(
              context,
              [
                _buildListItem(context, Icons.person, 'Personal Info', () {}),
                _buildListItem(context, Icons.location_on, 'Addresses', () {}),
              ],
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              [
                _buildListItem(context, Icons.shopping_cart, 'Cart', () {}),
                _buildListItem(context, Icons.favorite, 'Favourite', () {}),
                _buildListItem(context, Icons.notifications, 'Notifications', () {}),
                _buildListItem(context, Icons.payment, 'Payment Method', () {}),
              ],
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              [
                _buildListItem(context, Icons.help, 'FAQs', () {}),
                _buildListItem(context, Icons.info, 'About', () {}),
                _buildListItem(context, Icons.settings, 'Settings', () {}),
              ],
            ),
            SizedBox(height: 20),
            _buildSection(
              context,
              [
                _buildListItem(context, Icons.logout, 'Log Out', _handleSignOut, iconColor: Colors.red),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      color: Colors.blueGrey[700],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListItem(BuildContext context, IconData icon, String title, VoidCallback onTap, {Color iconColor = Colors.white}) {
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
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}
