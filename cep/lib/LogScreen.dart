import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class LogHealthDataScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) addHealthMetric;

  LogHealthDataScreen({required this.addHealthMetric});

  @override
  _LogHealthDataScreenState createState() => _LogHealthDataScreenState();
}

class _LogHealthDataScreenState extends State<LogHealthDataScreen> {
  final TextEditingController _bloodSugarController = TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _medicationController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _logHealthData() async {
    if (_formKey.currentState!.validate()) {
      // Create a health metric map with the current timestamp
      Map<String, dynamic> healthMetric = {
        'blood_sugar': _bloodSugarController.text,
        'blood_pressure': _bloodPressureController.text,
        'medication_taken': _medicationController.text,
        'createdAt': FieldValue.serverTimestamp(), // Add createdAt timestamp
      };

      // Save the health metric to Firestore
      await FirebaseFirestore.instance
          .collection('health_metrics')
          .add(healthMetric);

      // Optionally call the provided function
      widget.addHealthMetric(healthMetric);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Health data logged successfully')),
      );

      // Clear the fields after logging
      _bloodSugarController.clear();
      _bloodPressureController.clear();
      _medicationController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log Health Data"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your health metrics",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _bloodSugarController,
                decoration: InputDecoration(
                  labelText: "Blood Sugar Level (mg/dL)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your blood sugar level';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _bloodPressureController,
                decoration: InputDecoration(
                  labelText: "Blood Pressure (e.g., 120/80)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your blood pressure';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _medicationController,
                decoration: InputDecoration(
                  labelText: "Medication Taken",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the medication taken';
                  }
                  return null;
                },
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _logHealthData,
                  child: Text("Log Data"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
