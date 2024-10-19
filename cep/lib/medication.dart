import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) addMedication;

  MedicationScreen({required this.addMedication});

  @override
  _MedicationScreenState createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();

  Future<void> _addMedication() async {
    if (_formKey.currentState!.validate()) {
      DateTime selectedTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Add medication to Firestore
      await FirebaseFirestore.instance.collection('medications').add({
        'medication': _medicationController.text,
        'dosage': _dosageController.text,
        'time': selectedTime,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Medication added successfully'),
      ));

      // Clear the fields after logging
      _medicationController.clear();
      _dosageController.clear();
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Medication"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _medicationController,
                decoration: InputDecoration(
                  labelText: "Medication",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the medication name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(
                  labelText: "Dosage",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the dosage';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text("Select Time: ${_selectedTime.format(context)}"),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _addMedication,
                  child: Text("Add Medication"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
