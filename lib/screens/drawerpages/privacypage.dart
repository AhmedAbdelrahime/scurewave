import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
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
              'Privacy Policy',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to SecureWave!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This privacy policy explains how SecureWave collects, uses, and protects your information while using the app.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Data Collection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We collect personal data such as your email and login credentials for authentication and storing passwords securely.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. Data Usage',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your data is used solely for providing the services in SecureWave, such as managing your passwords and filtering SMS messages for phishing attacks.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. Data Security',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We implement advanced encryption to protect your data and ensure that it remains private and secure.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. Contact Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions or concerns about our privacy policy, please contact us at securewave@gmail.com.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
