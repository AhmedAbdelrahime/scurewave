import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phishing_detection_app/screens/homescreen/drwer_page.dart';
import 'package:phishing_detection_app/screens/password_manager_screen.dart';
import 'package:phishing_detection_app/screens/sms_permassain.dart';
import 'package:phishing_detection_app/screens/smsfitring.dart';
import 'package:phishing_detection_app/screens/url_scanning.dart';
import 'package:phishing_detection_app/widgets/card.dart';
import 'package:telephony/telephony.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  bool isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        userName = userDoc['name'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey, // Assign the key to Scaffold

      drawer: const DrwerPage(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start, UrlScanning()
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 55),
                        child: Text(
                          'Hello $userName !',
                          style: const TextStyle(
                            color: Color.fromARGB(255, 94, 127, 210),
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Explore Services',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: IconButton(
                        icon: const Icon(Icons.menu),
                        color: Colors.white,
                        onPressed: () {
                          _scaffoldKey.currentState
                              ?.openDrawer(); // Open drawer on click
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    CustomCard(
                      title: 'URL Scanning',
                      image: 'assets/10.png',
                      description: '',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UrlScanning()),
                        );
                      },
                    ),
                    const SizedBox(height: 25),
                    CustomCard(
                      title: 'SMS Filtering',
                      image: 'assets/7.png',
                      description: '',
                      onTap: () async {
                        final Telephony telephony = Telephony.instance;
                        bool? permissionsGranted =
                            await telephony.requestSmsPermissions;

                        if (permissionsGranted == true) {
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SmsDetectionScreen()),
                          );
                        } else {
                          Navigator.pushReplacement(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PermissionRequestScreen()),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 25),
                    CustomCard(
                      title: 'Password Manager',
                      image: 'assets/1.png',
                      description: '',
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PasswordManagerScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
