// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PasswordManagerScreen extends StatefulWidget {
//   const PasswordManagerScreen({Key? key}) : super(key: key);

//   @override
//   _PasswordManagerScreenState createState() => _PasswordManagerScreenState();
// }

// class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
//   final TextEditingController _accountController = TextEditingController();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   final User? user = FirebaseAuth.instance.currentUser;

//   Future<void> _addPassword() async {
//     if (_accountController.text.isNotEmpty &&
//         _usernameController.text.isNotEmpty &&
//         _passwordController.text.isNotEmpty) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user!.uid)
//           .collection('passwords')
//           .add({
//         'account': _accountController.text.trim(),
//         'username': _usernameController.text.trim(),
//         'password': _passwordController.text.trim(),
//       });

//       _accountController.clear();
//       _usernameController.clear();
//       _passwordController.clear();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Password saved successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields')),
//       );
//     }
//   }

//   Future<void> _deletePassword(String docId) async {
//     await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user!.uid)
//         .collection('passwords')
//         .doc(docId)
//         .delete();

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Password deleted successfully')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Password Manager'),
//         backgroundColor: Colors.black87,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextField(
//                 controller: _accountController,
//                 decoration: const InputDecoration(labelText: 'Account/Website'),
//               ),
//               TextField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(labelText: 'Username/Email'),
//               ),
//               TextField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _addPassword,
//                 child: const Text('Add Password'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black87,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('users')
//                     .doc(user!.uid)
//                     .collection('passwords')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   final passwords = snapshot.data!.docs;
//                   return ListView.builder(
//                     shrinkWrap: true, // Add this line
//                     physics: const NeverScrollableScrollPhysics(), // Add this line
//                     itemCount: passwords.length,
//                     itemBuilder: (context, index) {
//                       final passwordData = passwords[index].data() as Map<String, dynamic>;
//                       return ListTile(
//                         title: Text(passwordData['account']),
//                         subtitle: Text(passwordData['username']),
//                         trailing: IconButton(
//                           icon: const Icon(Icons.delete, color: Colors.red),
//                           onPressed: () => _deletePassword(passwords[index].id),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
