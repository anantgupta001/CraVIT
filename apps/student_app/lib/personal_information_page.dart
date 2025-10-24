import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cravit/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Removed image_picker and dart:io imports

class PersonalInformationPage extends StatefulWidget {
  final String fullName;
  final String email;
  final String? photoUrl; // Add photoUrl parameter

  const PersonalInformationPage({super.key, required this.fullName, required this.email, this.photoUrl}); // Update constructor

  @override
  State<PersonalInformationPage> createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _vitEmailController = TextEditingController();
  final TextEditingController _registrationNumberController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  String? _hostelDayScholar; // To store selected option
  final _formKey = GlobalKey<FormState>();
  // Removed File? _profileImage;

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.fullName;
    _vitEmailController.text = widget.email;
    _initializePersonalInformation(); // Call a new async function
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _vitEmailController.dispose();
    _registrationNumberController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black87 : Colors.white,
      appBar: AppBar(
        title: Text(
          'Personal Information',
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
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: isDarkMode ? Colors.blueGrey[700] : Colors.blueGrey[400],
                    backgroundImage: widget.photoUrl != null ? NetworkImage(widget.photoUrl!) : null, // Use NetworkImage if photoUrl is available
                    child: widget.photoUrl == null ? Icon(Icons.person, size: 70, color: isDarkMode ? Colors.white70 : Colors.black54) : null,
                  ),
                  // Removed Positioned camera icon for local image picking
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Hostel / Day Scholar',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.black54,
                fontSize: 16,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: _fullNameController,
                    labelText: 'Full Name',
                    hintText: 'For order identification',
                    icon: Icons.person,
                    isDarkMode: isDarkMode,
                    readOnly: true, // Make full name field non-editable
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _vitEmailController,
                    labelText: 'VIT Email ID',
                    hintText: 'anant.gupta2025@vitstudent.ac.in',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    isDarkMode: isDarkMode,
                    readOnly: true, // Make email field non-editable
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _registrationNumberController,
                    labelText: 'Registration Number (Optional)',
                    hintText: 'For campus verification',
                    icon: Icons.assignment_ind,
                    keyboardType: TextInputType.text, // Changed from TextInputType.number
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _mobileNumberController,
                    labelText: 'Mobile Number',
                    hintText: 'For order updates or delivery contact',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    isDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Hostel', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                    value: 'Hostel',
                    groupValue: _hostelDayScholar,
                    onChanged: (value) {
                      setState(() {
                        _hostelDayScholar = value;
                      });
                    },
                    activeColor: isDarkMode ? Colors.tealAccent[400] : Colors.blue,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: Text('Day Scholar', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                    value: 'Day Scholar',
                    groupValue: _hostelDayScholar,
                    onChanged: (value) {
                      setState(() {
                        _hostelDayScholar = value;
                      });
                    },
                    activeColor: isDarkMode ? Colors.tealAccent[400] : Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement saving personal information
                  _savePersonalInformation();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode ? Colors.tealAccent[400] : Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: Text(
                  'Save Information',
                  style: TextStyle(color: isDarkMode ? Colors.black : Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required bool isDarkMode,
    String? Function(String?)? validator, // Added validator parameter
    bool readOnly = false, // Added readOnly parameter
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      validator: validator, // Assign validator
      readOnly: readOnly, // Apply readOnly
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
        labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
        hintStyle: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black45),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? Colors.blueGrey[600]! : Colors.grey[400]!),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: isDarkMode ? Colors.tealAccent[400]! : Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: isDarkMode ? Colors.blueGrey[900] : Colors.grey[50],
      ),
    );
  }

  Future<void> _loadPersonalInformation() async {
    final prefs = await SharedPreferences.getInstance();
    _registrationNumberController.text = prefs.getString('registrationNumber') ?? '';
    _mobileNumberController.text = prefs.getString('mobileNumber') ?? '';
    // Only update if not null, otherwise retain initial 'Hostel' from _initializePersonalInformation
    final savedHostelDayScholar = prefs.getString('hostelDayScholar');
    if (savedHostelDayScholar != null) {
      setState(() {
        _hostelDayScholar = savedHostelDayScholar;
      });
    }
    // Removed profileImagePath loading logic
  }

  Future<void> _initializePersonalInformation() async {
    // Set initial value for hostel/day scholar if not loaded yet or first time
    if (_hostelDayScholar == null) {
      setState(() {
        _hostelDayScholar = 'Hostel'; // Default to Hostel
      });
    }
    await _loadPersonalInformation(); // Load other preferences
  }

  Future<void> _savePersonalInformation() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('registrationNumber', _registrationNumberController.text);
      await prefs.setString('mobileNumber', _mobileNumberController.text);
      await prefs.setString('hostelDayScholar', _hostelDayScholar ?? 'Hostel'); // Provide a default value
      // Removed profileImagePath saving logic

      // After saving, you might want to show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Personal information saved!')),
      );
    }
  }

  // Removed _pickImage function
}
