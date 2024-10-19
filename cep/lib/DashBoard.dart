import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String userEmail;

  DashboardScreen({
    required this.userName,
    required this.userEmail,
    required List<Map<String, dynamic>> healthMetrics,
    required List<Map<String, dynamic>> reminders,
    required List<Map<String, dynamic>> medications,
  });

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, dynamic>> healthMetrics = [];
  List<Map<String, dynamic>> reminders = [];
  List<Map<String, dynamic>> medications = [];

  @override
  void initState() {
    super.initState();
    _fetchRecentHealthMetrics();
    _fetchReminders();
    _fetchMedications(); // Fetch medications from Firestore
  }

  // Fetch recent health metrics from Firestore
  Future<void> _fetchRecentHealthMetrics() async {
    final now = DateTime.now();
    final twentyFourHoursAgo = now.subtract(Duration(hours: 24));

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('health_metrics')
        .where('createdAt',
            isGreaterThan: Timestamp.fromDate(twentyFourHoursAgo))
        .get();

    List<Map<String, dynamic>> fetchedMetrics = querySnapshot.docs.map((doc) {
      return {
        'blood_pressure': doc['blood_pressure'],
        'blood_sugar': doc['blood_sugar'],
        'createdAt': doc['createdAt'].toDate(),
      };
    }).toList();

    setState(() {
      healthMetrics = fetchedMetrics;
    });
  }

  // Fetch reminders from Firestore
  Future<void> _fetchReminders() async {
    final now = DateTime.now();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('reminders')
        .where('date',
            isGreaterThan: Timestamp.now()) // Filter expired reminders
        .get();

    List<Map<String, dynamic>> fetchedReminders = querySnapshot.docs.map((doc) {
      return {
        'reminder_type': doc['reminder_type'],
        'date': doc['date'].toDate(),
        'id': doc.id,
      };
    }).toList();

    setState(() {
      reminders = fetchedReminders;
    });

    _deleteExpiredReminders(); // Automatically delete expired reminders
  }

  // Fetch medications from Firestore
  Future<void> _fetchMedications() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('medications').get();

    List<Map<String, dynamic>> fetchedMedications =
        querySnapshot.docs.map((doc) {
      return {
        'medication': doc['medication'],
        'dosage': doc['dosage'],
        'time': (doc['time'] as Timestamp).toDate(),
        'id': doc.id,
      };
    }).toList();

    setState(() {
      medications = fetchedMedications;
    });
  }

  // Delete expired reminders from Firestore
  Future<void> _deleteExpiredReminders() async {
    final now = DateTime.now();
    for (var reminder in reminders) {
      if (reminder['date'].isBefore(now)) {
        await FirebaseFirestore.instance
            .collection('reminders')
            .doc(reminder['id'])
            .delete();
      }
    }
    _fetchReminders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Dashboard"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message with user name
            Text(
              'Welcome, ${widget.userName}!',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),

            // Vitals Section
            const Text(
              "Vitals",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            healthMetrics.isNotEmpty
                ? Column(
                    children: healthMetrics.map((metric) {
                      return Column(
                        children: [
                          _buildVitalsCard(
                              "Blood Pressure",
                              metric['blood_pressure'],
                              "assets/images/blood pressure.png"),
                          const SizedBox(height: 10),
                          _buildVitalsCard("Blood Sugar", metric['blood_sugar'],
                              "assets/images/sugar.png"),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  )
                : const Text(
                    "No health data logged in the last 24 hours.",
                    style: TextStyle(color: Colors.redAccent),
                  ),

            const SizedBox(height: 20),

            // Reminders Section
            const Text(
              "Reminders",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            reminders.isNotEmpty
                ? Column(
                    children: reminders.map((reminder) {
                      return _buildReminderCard(reminder);
                    }).toList(),
                  )
                : const Text(
                    "No upcoming reminders.",
                    style: TextStyle(color: Colors.redAccent),
                  ),

            const SizedBox(height: 20),

            // Medications Section
            const Text(
              "Medications",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            medications.isNotEmpty
                ? Column(
                    children: medications.map((medication) {
                      return _buildMedicationCard(medication);
                    }).toList(),
                  )
                : const Text(
                    "No medications logged.",
                    style: TextStyle(color: Colors.redAccent),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalsCard(String title, String value, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            Image.asset(
              imagePath,
              height: 50,
              width: 80,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder) {
    final reminderDate = reminder['date'] as DateTime;
    final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(reminderDate);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder['reminder_type'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Scheduled for: $formattedDate",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                // Delete the reminder when user presses delete
                await FirebaseFirestore.instance
                    .collection('reminders')
                    .doc(reminder['id'])
                    .delete();

                // Refresh reminders after deletion
                _fetchReminders();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicationCard(Map<String, dynamic> medication) {
    final medicationTime = medication['time'] as DateTime;
    final formattedTime = DateFormat('HH:mm').format(medicationTime);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medication['medication'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Dosage: ${medication['dosage']}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
                Text(
                  "Time: $formattedTime",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () async {
                // Delete the medication when user presses delete
                await FirebaseFirestore.instance
                    .collection('medications')
                    .doc(medication['id'])
                    .delete();

                // Refresh medications after deletion
                _fetchMedications();
              },
            ),
          ],
        ),
      ),
    );
  }
}
