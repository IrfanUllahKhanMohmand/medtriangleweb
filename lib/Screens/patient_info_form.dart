import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientForm extends StatefulWidget {
  final String docId;
  const PatientForm({Key? key, required this.docId}) : super(key: key);

  @override
  _PatientFormState createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _consultDrController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _bedController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  PlatformFile? _selectedImage;
  String? _uploadedImageUrl;

  @override
  void initState() {
    super.initState();
    fetchDefaultFieldValues();
  }

  Future<void> fetchDefaultFieldValues() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('patientinfo')
          .doc(widget.docId)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        _nameController.text = data['Name'] ?? '';
        _birthdayController.text = data['Birthday'] ?? '';
        _genderController.text = data['Gender'] ?? '';
        _cnicController.text = data['CNIC'] ?? '';
        _phoneController.text = data['Phone'] ?? '';
        _addressController.text = data['Adress'] ?? '';
        _emailController.text = data['Email'] ?? '';
        _bloodTypeController.text = data['BloodType'] ?? '';
        _consultDrController.text = data['ConsultDr'] ?? '';
        _wardController.text = data['Ward'] ?? '';
        _bedController.text = data['Bed'] ?? '';
        _imageUrlController.text = data['imageUrl'] ?? '';
      }
      setState(() {});
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

  Future<void> updateFirestoreDocument(String downloadUrl) async {
    try {
      final updatedData = {
        'Name': _nameController.text,
        'Birthday': _birthdayController.text,
        'Gender': _genderController.text,
        'CNIC': _cnicController.text,
        'Phone': _phoneController.text,
        'Adress': _addressController.text,
        'Email': _emailController.text,
        'BloodType': _bloodTypeController.text,
        'ConsultDr': _consultDrController.text,
        'Ward': _wardController.text,
        'Bed': _bedController.text,
        'imageUrl': downloadUrl,
      };

      await FirebaseFirestore.instance
          .collection('patientinfo')
          .doc(widget.docId)
          .update(updatedData);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Document updated successfully'),
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

  void _selectImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedImage = result.files.first;
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final destination = 'images/$fileName';
      final storageRef = FirebaseStorage.instance.ref().child(destination);
      final UploadTask uploadTask = storageRef.putData(_selectedImage!.bytes!);

      uploadTask.whenComplete(() => null).then((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.success) {
          final downloadUrl = await storageRef.getDownloadURL();
          setState(() {
            _uploadedImageUrl = downloadUrl;
            print(_uploadedImageUrl);
          });

          return _uploadedImageUrl;
        } else {
          // Handle error during image upload
          print('Error uploading image');
        }
      });
      return _uploadedImageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Form'),
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
                  controller: _cnicController,
                  decoration: const InputDecoration(
                    labelText: 'CNIC',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a CNIC';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
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
                  controller: _consultDrController,
                  decoration: const InputDecoration(
                    labelText: 'Consulting Doctor',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a consulting doctor';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _wardController,
                  decoration: const InputDecoration(
                    labelText: 'Ward',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a ward number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _bedController,
                  decoration: const InputDecoration(
                    labelText: 'Bed',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a bed number';
                    }
                    return null;
                  },
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: MemoryImage(_selectedImage!.bytes!),
                            fit: BoxFit.cover,
                          )
                        : _uploadedImageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(_uploadedImageUrl!),
                                fit: BoxFit.cover,
                              )
                            : _imageUrlController.text.isNotEmpty
                                ? DecorationImage(
                                    image:
                                        NetworkImage(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    _selectImage();
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text('Select Image'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _uploadImage().then((downloadUrl) {
                        updateFirestoreDocument(downloadUrl!);
                      });
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
