import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TreatmentForm extends StatefulWidget {
  final String docId;

  const TreatmentForm({super.key, required this.docId});
  @override
  _TreatmentFormState createState() => _TreatmentFormState();
}

class _TreatmentFormState extends State<TreatmentForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _medicinesController = TextEditingController();
  TextEditingController _injectionsController = TextEditingController();
  TextEditingController _surgeryController = TextEditingController();
  TextEditingController _dropsController = TextEditingController();
  TextEditingController _foodController = TextEditingController();
  Future<void> initializeFieldValues() async {
    try {
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('treatment')
          .doc(widget.docId) // Replace 'patient_id' with the actual patient ID
          .get();

      if (document.exists) {
        setState(() {
          _medicinesController.text = document.get('Medicines') ?? '';
          _injectionsController.text = document.get('Injections') ?? '';
          _surgeryController.text = document.get('Surgery') ?? '';
          _dropsController.text = document.get('Drops') ?? '';
          _foodController.text = document.get('Food') ?? '';
        });
      }
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to initialize field values: $error'),
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
          .collection('treatment')
          .doc(widget.docId) // Replace 'patient_id' with the actual patient ID
          .update({
        'Medicines': _medicinesController.text,
        'Injections': _injectionsController.text,
        'Surgery': _surgeryController.text,
        'Drops': _dropsController.text,
        'Food': _foodController.text,
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
  void initState() {
    initializeFieldValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treatment Form'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _medicinesController,
                  decoration: const InputDecoration(
                    labelText: 'Medicines',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter medicines information';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _injectionsController,
                  decoration: const InputDecoration(
                    labelText: 'Injections',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter injections information';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _surgeryController,
                  decoration: const InputDecoration(
                    labelText: 'Surgery',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter surgery information';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dropsController,
                  decoration: const InputDecoration(
                    labelText: 'Drops',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter drops information';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _foodController,
                  decoration: const InputDecoration(
                    labelText: 'Food',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter food information';
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
