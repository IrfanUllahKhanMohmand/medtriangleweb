import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medtriangleweb/models/patient_info_model.dart';

import '../main.dart';

class PatientInfoScreen extends StatefulWidget {
  @override
  State<PatientInfoScreen> createState() => _PatientInfoScreenState();
}

class _PatientInfoScreenState extends State<PatientInfoScreen> {
  Future<void> _refreshData() async {
    setState(() {
      // Reset the data to null to show loading indicator
      // You can also set an empty list if you want to clear the data immediately
      // Instead of showing a loading indicator
    });

    await _fetchData();

    // Add any additional processing or error handling as needed

    setState(() {
      // Update the UI with the retrieved data or error message
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchData() {
    return FirebaseFirestore.instance.collection('patientinfo').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ALL PATIENTS'),
        actions: [
          InkWell(
              onTap: () {
                _refreshData();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(Icons.refresh_outlined),
              ))
        ],
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _fetchData(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            List<PatientInfoModel> ls = snapshot.data!.docs
                .map((doc) => PatientInfoModel.fromJson(doc.data()))
                .toList();

            return Column(
              children: [
                ListTile(
                  title: const Text('Add New Patient'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SignUpAlertDialog();
                      },
                    );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .80,
                  child: ListView.builder(
                    itemCount: ls.length,
                    itemBuilder: (BuildContext context, int index) {
                      final document = documents[index];

                      // Replace 'name' with the actual field name in the document
                      final name = document['Name'];

                      return ListTile(
                        title: Text(name),
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return BottomNavBarScreen(
                              docId: document.id,
                            );
                          }));
                        },
                        onLongPress: () async {
                          await showDeleteConfirmationDialog(
                              context, document.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: Text('No data available'),
          );
        },
      ),
    );
  }
}

Future<void> showDeleteConfirmationDialog(
    BuildContext context, String userId) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteUserAndDocuments(userId); // Call the delete user function
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

Future<void> deleteUserAndDocuments(String id) async {
  // Delete documents from Firestore collections
  await FirebaseFirestore.instance.collection('patientinfo').doc(id).delete();
  await FirebaseFirestore.instance.collection('medicalinfo').doc(id).delete();
  await FirebaseFirestore.instance.collection('treatment').doc(id).delete();
  await FirebaseFirestore.instance.collection('labtests').doc(id).delete();
}

class SignUpAlertDialog extends StatefulWidget {
  @override
  _SignUpAlertDialogState createState() => _SignUpAlertDialogState();
}

class _SignUpAlertDialogState extends State<SignUpAlertDialog> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  Future<void> _createUserWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String name = _nameController.text.trim();

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // User creation successful
      print('User created: ${userCredential.user?.uid}');

      // Insert documents into collections
      await FirebaseFirestore.instance
          .collection('patientinfo')
          .doc(userCredential.user!.uid)
          .set({
        'Name': name,
        'Birthday': '',
        'Gender': '',
        'CNIC': '',
        'Phone': '',
        'Adress': '',
        'Email': '',
        'BloodType': '',
        'ConsultDr': '',
        'Ward': '',
        'Bed': '',
        'imageUrl': '',
      });

      await FirebaseFirestore.instance
          .collection('medicalinfo')
          .doc(userCredential.user!.uid)
          .set({
        'Name': name,
        'Birthday': '',
        'Gender': '',
        'BloodType': '',
        'Diagnosis': '',
        'BP': '',
        'Sugar': '',
        'BloodTest': '',
      });

      await FirebaseFirestore.instance
          .collection('treatment')
          .doc(userCredential.user!.uid)
          .set({
        'Medicines': '',
        'Injections': '',
        'Surgery': '',
        'Drops': '',
        'Food': '',
      });

      DocumentReference reportDocRef = FirebaseFirestore.instance
          .collection('labtests')
          .doc(userCredential.user!.uid)
          .collection('reports')
          .doc();

      await reportDocRef.set({
        'Name': '',
        'Date': '', // Save the date field
        'Result': '',
        'id': reportDocRef.id,
      });

      // Close the dialog
      Navigator.pop(context);
    } catch (e) {
      // User creation failed
      print('Error creating user: $e');

      // Show an error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to create user. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createUserWithEmailAndPassword,
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
