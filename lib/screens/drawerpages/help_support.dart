import 'package:flutter/material.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: Colors.black, // Set the background color to black
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help & Support',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Need assistance? We are here to help you with any questions or issues you may have regarding SecureWave.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Frequently Asked Questions (FAQs)',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '1. How do I reset my password?\n'
              'You can reset your password by clicking "Forgot Password" on the login screen and following the instructions.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. How do I delete my account?\n'
              'To delete your account, go to icon menu  settings and select "Delete Account." You can also contact support for assistance.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. How do I report a phishing SMS?\n'
              'If you receive a suspicious SMS, SecureWave will automatically scan it for phishing attempts. If it’s not flagged and you believe it’s malicious, please forward the message to our support team.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you need further assistance, feel free to reach out to us at:\n\n'
              'Email: securewave@gmail.com\n'
              'Support Hours: Monday - Friday, 9 AM - 5 PM (UTC)',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Function to launch email client
}
