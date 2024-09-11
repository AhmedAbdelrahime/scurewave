import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      backgroundColor: Colors.black, // Set the background color to black
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
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
              'By using SecureWave, you agree to the following terms and conditions. Please read them carefully.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '1. Account Registration',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'To use SecureWave, you must register an account with accurate information. You are responsible for maintaining the confidentiality of your account credentials.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. Use of the Service',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You agree to use SecureWave only for lawful purposes. You must not use the app to store or share illegal content or engage in fraudulent activities.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. User Responsibilities',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You are responsible for the security of your account and the data you store in the app. SecureWave is not liable for any data loss due to unauthorized access to your account.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '4. Limitation of Liability',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'SecureWave is not liable for any damages or losses resulting from the use or inability to use the app. The service is provided "as is" without any warranties.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '5. Changes to the Terms',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'SecureWave reserves the right to update these terms at any time. You will be notified of any significant changes, and continued use of the app constitutes acceptance of the updated terms.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '6. Contact Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'If you have any questions about these terms, please contact us at securewave@gmail.com.',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
