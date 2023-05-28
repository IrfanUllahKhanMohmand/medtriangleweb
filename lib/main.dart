import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medtriangleweb/models/patient_info_model.dart';

import 'Screens/lab_test_info.dart';
import 'Screens/medical_info_form.dart';
import 'Screens/patient_info_form.dart';
import 'Screens/patient_info_screen.dart';
import 'Screens/treatment_info_form.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MEDTRIANGLE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientInfoScreen(),
    );
  }
}

class BottomNavBarScreen extends StatefulWidget {
  final String docId;
  const BottomNavBarScreen({super.key, required this.docId});

  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int _currentIndex = 0;

  late List<Widget> _tabs;

  @override
  void initState() {
    _tabs = [
      PatientForm(docId: widget.docId),
      MedicalInfoForm(docId: widget.docId),
      TreatmentForm(docId: widget.docId),
      LabTestForm(docId: widget.docId),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Patient Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline),
            label: 'Medical Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined),
            label: 'Treatment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.biotech_rounded),
            label: 'Laboratory Tests',
          ),
        ],
      ),
    );
  }
}
