import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalInfoForm extends StatefulWidget {
  final String docId;

  const MedicalInfoForm({super.key, required this.docId});
  @override
  _MedicalInfoFormState createState() => _MedicalInfoFormState();
}

class _MedicalInfoFormState extends State<MedicalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _bloodTypeController = TextEditingController();
  TextEditingController _diagnosisController = TextEditingController();
  TextEditingController _bpController = TextEditingController();
  TextEditingController _sugarController = TextEditingController();
  TextEditingController _bloodTestController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDefaultFieldValues();
  }

  Future<void> fetchDefaultFieldValues() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('medicalinfo')
          .doc(widget.docId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['Name'] ?? '';
          _birthdayController.text = data['Birthday'] ?? '';
          _genderController.text = data['Gender'] ?? '';
          _bloodTypeController.text = data['BloodType'] ?? '';
          _diagnosisController.text = data['Diagnosis'] ?? '';
          _bpController.text = data['BP'] ?? '';
          _sugarController.text = data['Sugar'] ?? '';
          _bloodTestController.text = data['BloodTest'] ?? '';
        });
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to fetch default values: $error'),
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

  Future<void> updateFirestoreDocument() async {
    try {
      await FirebaseFirestore.instance
          .collection('medicalinfo')
          .doc(widget.docId) // Replace 'patient_id' with the actual patient ID
          .update({
        'Name': _nameController.text,
        'Birthday': _birthdayController.text,
        'Gender': _genderController.text,
        'BloodType': _bloodTypeController.text,
        'Diagnosis': _diagnosisController.text,
        'BP': _bpController.text,
        'Sugar': _sugarController.text,
        'BloodTest': _bloodTestController.text,
      });

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
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to update document: $error'),
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
        title: const Text('Medical Info Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _birthdayController,
                  decoration: const InputDecoration(
                    labelText: 'Birthday',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a birthday';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a gender';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bloodTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Blood Type',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a blood type';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _diagnosisController,
                  decoration: const InputDecoration(
                    labelText: 'Diagnosis',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a diagnosis';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bpController,
                  decoration: const InputDecoration(
                    labelText: 'Blood Pressure (BP)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a blood pressure';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _sugarController,
                  decoration: const InputDecoration(
                    labelText: 'Sugar Level',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a sugar level';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bloodTestController,
                  decoration: const InputDecoration(
                    labelText: 'Blood Test Result',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a blood test result';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      updateFirestoreDocument();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
