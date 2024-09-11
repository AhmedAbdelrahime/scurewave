import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:phishing_detection_app/screens/drawerpages/privacypage.dart';
import 'package:phishing_detection_app/screens/drawerpages/termofser.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../auth/loginscreen.dart';
import '../drawerpages/aboutpage.dart';
import '../drawerpages/help_support.dart';

class DrwerPage extends StatefulWidget {
  const DrwerPage({super.key});

  @override
  State<DrwerPage> createState() => _DrwerPageState();
}

class _DrwerPageState extends State<DrwerPage> {
  // bool _isConnecting = false;

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAuthenticated', false);

    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> deleteAccountData(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    User? user = auth.currentUser; // Get the current user

    if (user == null) {
      // Handle case where the user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user is currently logged in.')),
      );
      return;
    }

    String userId = user.uid; // Get the user ID

    // Store the current Navigator and ScaffoldMessenger to avoid issues with context
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Delete user data from Firestore
      await firestore.collection('users').doc(userId).delete();

      // Delete the user account from Firebase Authentication
      await user.delete();

      // Sign out the user after deletion
      await auth.signOut();

      // Notify the user of successful deletion
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Account and data deleted successfully')),
      );

      // Navigate back to the login screen after deletion
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      // Handle errors
      if (kDebugMode) {
        print('Error deleting account: $e');
      }

      // Notify the user of the error
      scaffoldMessenger.showSnackBar(
        const SnackBar(
            content: Text('Failed to delete account. Please try again.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Row(
            children: [
              Icon(Icons.account_circle, color: Colors.redAccent),
              SizedBox(width: 10),
              Text(
                'Delete Account and Data',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to permanently delete your account, all saved passwords, and any associated data? '
            'This action cannot be undone, and you will lose all your information stored in SecureWave.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                deleteAccountData(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Row(
            children: [
              Icon(Icons.logout, color: Colors.redAccent),
              SizedBox(width: 10),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Drawer(
        clipBehavior: Clip.antiAlias, // Define clipping behavior
        elevation: 1.0, // Elevation for the drawer shadow
        semanticLabel: 'Main Menu', // Accessibility label
        shadowColor: Colors.blue.withOpacity(1), // Shadow color
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(40),
            left: Radius.circular(20),
            // Rounded corners
          ),
        ),
        width: 210.0,

        // Width of the drawer
        surfaceTintColor: Colors.blue.withOpacity(0.7), // Surface tint color
        backgroundColor: Colors.black, // Background color
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo.png', // Replace with your logo asset path
                    height: 50, // Adjust size as needed
                  ),
                  const SizedBox(width: 8), // Space between logo and text
                  const Text(
                    'SecureWave',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const FaIcon(
                // ignore: deprecated_member_use
                FontAwesomeIcons.fileAlt,
                color: Color(0xFF8A8A8A),
              ),
              title: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const FaIcon(
                FontAwesomeIcons.fileContract,
                color: Color(0xFF8A8A8A),
              ),
              title: const Text(
                'Terms of Service',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermsOfServicePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info,
                color: Color(0xFF8A8A8A),
              ),
              title: const Text(
                'About SecureWave',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.folder_delete_rounded,
                color: Color(0xFF8A8A8A),
              ),
              title: const Text(
                'Delete Account and Data',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => showDeleteAccountDialog(),
            ),
            ListTile(
              leading: const Icon(
                Icons.help,
                color: Color(0xFF8A8A8A),
              ),
              title: const Text(
                'Help & Support',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpSupportPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Color(0xFF8A8A8A),
              ),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => _showLogoutDialog(),
            ),
          ],
        ),
      ),
    );
  }
}
