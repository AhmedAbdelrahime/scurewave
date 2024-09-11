import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phishing_detection_app/screens/homescreen/home_screen.dart';
import 'package:phishing_detection_app/widgets/custom_text_field.dart';
import 'package:phishing_detection_app/widgets/custourlextfield.dart';
import 'package:phishing_detection_app/widgets/snakbar.dart';
import 'package:flutter/services.dart';

class PasswordManagerScreen extends StatefulWidget {
  const PasswordManagerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordManagerScreenState createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> _addPassword() async {
    if (_accountController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('passwords')
          .add({
        'account': _accountController.text.trim(),
        'username': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
      });

      _accountController.clear();
      _usernameController.clear();
      _passwordController.clear();

      // ignore: use_build_context_synchronously
      SnackbarHelper(context).showMessage(
        'Password saved successfully',
        backgroundColor: Colors.green,
      );
    } else {
      SnackbarHelper(context).showMessage(
        'Please fill all fields',
      );
    }
  }

  Future<void> _deletePassword(String docId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('passwords')
        .doc(docId)
        .delete();
    // ignore: use_build_context_synchronously
    SnackbarHelper(context).showMessage(
      'Password deleted successfully',
      backgroundColor: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Password Manager',
          style: TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    CustomTextField(
                      onChanged: (value) {
                        setState(() {});
                      },
                      controller: _searchController,
                      keyboardType: TextInputType.url,
                      labelText: 'Search Password',
                      hintText: 'Search passwords..',
                      icon: Icons.search,
                      fillColor: Colors.black54,
                      borderColor: Colors.white70,
                      focusedBorderColor: Colors.blueAccent,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      hintText: 'Account/Website',
                      icon: Icons.web_asset,
                      keyboardType: TextInputType.url,
                      controller: _accountController,
                    ),
                    CustomTextFormField(
                      hintText: 'Username/Email',
                      icon: Icons.person,
                      keyboardType: TextInputType.emailAddress,
                      controller: _usernameController,
                    ),
                    CustomTextFormField(
                      hintText: 'Password',
                      icon: Icons.lock,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      isPassword: true,
                    ),
                    ElevatedButton(
                      onPressed: _addPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.3),
                      ),
                      child: const Text(
                        'Add Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .collection('passwords')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final passwords = snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final account =
                            data['account'].toString().toLowerCase();
                        final username =
                            data['username'].toString().toLowerCase();
                        final query = _searchController.text.toLowerCase();

                        return account.contains(query) ||
                            username.contains(query);
                      }).toList();

                      if (passwords.isEmpty) {
                        return const Center(
                            child: Text(
                          'No passwords found',
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ));
                      }

                      return ListView.builder(
                        itemCount: passwords.length,
                        itemBuilder: (context, index) {
                          final passwordData =
                              passwords[index].data() as Map<String, dynamic>;
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.grey[900],
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              leading: const CircleAvatar(
                                backgroundColor: Colors.blueAccent,
                                child:
                                    Icon(Icons.security, color: Colors.white),
                              ),
                              title: Text(
                                passwordData['account'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                passwordData['username'],
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[400]),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () =>
                                    _deletePassword(passwords[index].id),
                              ),
                              onTap: () {
                                _showPasswordDetails(passwordData);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard!')),
    );
  }

  void _showPasswordDetails(Map<String, dynamic> passwordData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black.withOpacity(.8),
          title: const Text(
            'Password Details',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.account_circle, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        passwordData['username'],
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.blue,
                      ),
                      onPressed: () =>
                          _copyToClipboard(passwordData['username']),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.lock, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        passwordData['password'],
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, color: Colors.blue),
                      onPressed: () =>
                          _copyToClipboard(passwordData['password']),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
