import 'package:cep/Insights.dart';
import 'package:cep/LogScreen.dart';
import 'package:cep/Reminder.dart';
import 'package:cep/Signin.dart';
import 'package:cep/firebase_options.dart';
import 'package:cep/medication.dart';
import 'package:cep/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'DashBoard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainAppScreen extends StatefulWidget {
  @override
  _MainAppScreenState createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  // Data lists for health metrics, reminders, and medications
  List<Map<String, dynamic>> healthMetrics = [];
  List<Map<String, dynamic>> reminders = [];
  List<Map<String, dynamic>> medications = [];

  String userName = 'John Doe';
  String userEmail = 'johndoe@gmail.com';

  // List of Screens for Bottom Navigation
  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens = [
      DashboardScreen(
        healthMetrics: healthMetrics,
        reminders: reminders,
        medications: medications,
        userName: userName,
        userEmail: userEmail,
      ),
      LogHealthDataScreen(
        addHealthMetric: addHealthMetric,
      ),
      HealthInsightsScreen(),
      MedicationScreen(addMedication: addMedication),
      RemindersScreen(addReminder: addReminder),
      ProfileScreen(
        updateProfile: updateProfile,
        currentName: '',
        currentEmail: '',
      ),
    ];
  }

  // Function to add or update health metrics
  void addHealthMetric(Map<String, dynamic> metric) {
    setState(() {
      healthMetrics.add(metric);
      _updateDashboardScreen();
    });
  }

  // Function to add medications
  void addMedication(Map<String, dynamic> medication) {
    setState(() {
      medications.add(medication);
      _updateDashboardScreen();
    });
  }

  // Function to add reminders
  void addReminder(Map<String, dynamic> reminder) {
    setState(() {
      reminders.add(reminder);
      _updateDashboardScreen();
    });
  }

  // Function to update profile
  void updateProfile(String name, String email) {
    setState(() {
      userName = name;
      userEmail = email;
      _updateDashboardScreen();
    });
  }

  // Function to refresh the DashboardScreen after updates
  void _updateDashboardScreen() {
    _screens[0] = DashboardScreen(
      healthMetrics: healthMetrics,
      reminders: reminders,
      medications: medications,
      userName: userName,
      userEmail: userEmail,
    );
  }

  // Function to update the index when a tab is clicked
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
              color: Colors.lightBlueAccent,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add,
              color: Colors.lightBlueAccent,
            ),
            label: 'Log Health Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.insights,
              color: Colors.lightBlueAccent,
            ),
            label: 'Health Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.medication,
              color: Colors.lightBlueAccent,
            ),
            label: 'Medications',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.lightBlueAccent,
            ),
            label: 'Reminders',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.lightBlueAccent,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, // Keep track of selected index
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped, // Change the screen when a tab is selected
      ),
    );
  }
}
