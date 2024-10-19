import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RemindersScreen extends StatefulWidget {
  final Function addReminder;

  RemindersScreen({required this.addReminder});

  @override
  _RemindersScreenState createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  final TextEditingController _reminderController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();

  void _addReminder() async {
    if (_formKey.currentState!.validate()) {
      DateTime selectedDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      // Add reminder to Firestore
      await FirebaseFirestore.instance.collection('reminders').add({
        'reminder_type': _reminderController.text,
        'date': selectedDateTime,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reminder added successfully'),
      ));

      // Clear the fields after adding
      _reminderController.clear();
      setState(() {
        _selectedDate = DateTime.now();
        _selectedTime = TimeOfDay.now();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
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
        title: Text("Manage Reminders"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Set a Reminder",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _reminderController,
                decoration: InputDecoration(
                  labelText: "Reminder",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a reminder';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  "Select Date: ${_selectedDate.toLocal()}".split(' ')[0],
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text("Select Time: ${_selectedTime.format(context)}"),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _addReminder,
                  child: Text("Add Reminder"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
