import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phishing_detection_app/auth/signupscreen.dart';

import 'package:phishing_detection_app/screens/homescreen/home_screen.dart';
import 'package:phishing_detection_app/widgets/cousetombutton.dart';
import 'package:phishing_detection_app/widgets/custom_text_field.dart';
import 'package:phishing_detection_app/widgets/snakbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSigningIn = false;

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      SnackbarHelper(context).showMessage(handleFirebaseAuthError(e));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          _isSigningIn = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', true);
        Navigator.pushAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        await FirebaseAuth.instance.signOut();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAuthenticated', false);
      }
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      SnackbarHelper(context).showMessage(handleFirebaseAuthError(e));
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    final TextEditingController forgotPasswordController =
        TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Adjust overall padding here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: forgotPasswordController,
                  hintText: "Enter your email",
                  icon: FontAwesomeIcons.envelope,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent,
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
                    const SizedBox(width: 8),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                      child: const Text(
                        "Send",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () async {
                        final email = forgotPasswordController.text.trim();
                        if (email.isNotEmpty) {
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);
                            // ignore: use_build_context_synchronously
                            SnackbarHelper(context).showMessage(
                                'Password reset email sent. Please check your inbox.');
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pop();
                          } on FirebaseAuthException catch (e) {
                            // ignore: use_build_context_synchronously
                            SnackbarHelper(context)
                                .showMessage(handleFirebaseAuthError(e));
                          }
                        } else {
                          SnackbarHelper(context).showMessage(
                              'Please enter a valid email address.');
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/welcom.png', // Replace with your image asset path
                  height: 90,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome Back ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please log in with your email and password to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  icon: FontAwesomeIcons.envelope,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  icon: FontAwesomeIcons.lock,
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _showForgotPasswordDialog,
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Cousetombutton(
                        text: 'Login',
                        icon: FontAwesomeIcons.arrowRight,
                        onpressed: _signInWithEmailAndPassword,
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Dont have account? ",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Creat Account",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  "OR",
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                _isSigningIn
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : GestureDetector(
                        onTap: _signInWithGoogle,
                        child: SizedBox(
                          height: 60,
                          width: 300,
                          child: Image.asset(
                            'assets/androidsi.png', // Replace with your Google icon asset path
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'The user with this email has been disabled.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'operation-not-allowed':
        return 'Email and password accounts are not enabled.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An undefined Error happened.';
    }
  }
}
