import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/lab_test_model.dart';

class LabTestForm extends StatefulWidget {
  final String docId;

  const LabTestForm({Key? key, required this.docId}) : super(key: key);

  @override
  _LabTestFormState createState() => _LabTestFormState();
}

class _LabTestFormState extends State<LabTestForm> {
  final _formKey = GlobalKey<FormState>();
  List<LabTestModel> labTests = []; // List to store the fetched lab test data

  @override
  void initState() {
    super.initState();
    fetchPatientInfo(); // Fetch patient lab test data on initialization
  }

  Future<void> fetchPatientInfo() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('labtests')
              .doc(widget.docId)
              .collection('reports')
              .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          labTests = snapshot.docs
              .map((doc) => LabTestModel.fromJson(doc.data()))
              .toList();
        });
      } else {
        throw Exception('Patient not found');
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to fetch patient information: $error'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Test Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Dynamically generate the TextFormField based on the fetched lab test data
              for (int i = 0; i < labTests.length; i++)
                Column(
                  children: [
                    Text('Test ${i + 1}'),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter test information';
                        }
                        return null;
                      },
                      initialValue: labTests[i].name,
                      onSaved: (value) {
                        labTests[i].name = value ?? '';
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a date';
                        }
                        return null;
                      },
                      initialValue: labTests[i].date,
                      onSaved: (value) {
                        labTests[i].date = value ?? '';
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Result',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a result';
                        }
                        return null;
                      },
                      initialValue: labTests[i].result,
                      onSaved: (value) {
                        labTests[i].result = value ?? '';
                      },
                    ),
                    const SizedBox(height: 20)
                  ],
                ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Process the form data and update the lab test data

                    // Update the lab test data in Firestore
                    for (int i = 0; i < labTests.length; i++) {
                      await FirebaseFirestore.instance
                          .collection('labtests')
                          .doc(widget.docId)
                          .collection('reports')
                          .doc(labTests[i].id)
                          .update({
                        'Name': labTests[i].name,
                        'Date': labTests[i].date, // Save the date field
                        'Result': labTests[i].result, // Save the result field
                      });
                    }

                    // Show a success message or navigate to the next screen
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Success'),
                          content: const Text('Form submitted successfully'),
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
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
