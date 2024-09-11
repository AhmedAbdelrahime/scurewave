import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:phishing_detection_app/screens/smsfitring.dart';
import 'package:phishing_detection_app/widgets/cousetombutton.dart';

class PermissionRequestScreen extends StatelessWidget {
  const PermissionRequestScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void navigateToNextStep() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SmsDetectionScreen()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 100, horizontal: 35),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/8.png",
                    height: 300,
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Request Permission',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'We need permission to read your SMS messages in order to detect phishing attempts and protect you from potential scams.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  // custom button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Cousetombutton(
                      text: 'Grant Permission',
                      onpressed: () {
                        navigateToNextStep();
                      },
                      icon: FontAwesomeIcons.arrowRight,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
