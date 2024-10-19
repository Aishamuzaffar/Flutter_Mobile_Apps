import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Map<String, String>> events = [];

  // Function to open the dialog to add a new event
  Future<void> _showAddEventDialog() async {
    final TextEditingController eventNameController = TextEditingController();
    final TextEditingController organizerNameController =
        TextEditingController();
    XFile? selectedImage;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: eventNameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: organizerNameController,
                decoration: const InputDecoration(labelText: 'Organizer Name'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  selectedImage =
                      await picker.pickImage(source: ImageSource.gallery);
                  setState(() {});
                },
                child: const Text('Upload Image'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (eventNameController.text.isNotEmpty &&
                  organizerNameController.text.isNotEmpty &&
                  selectedImage != null) {
                setState(() {
                  events.add({
                    'eventType': eventNameController.text,
                    'organizer': organizerNameController.text,
                    'image': selectedImage!.path
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: events.isNotEmpty
              ? events.map((event) {
                  String eventName = event['eventType']!;
                  String organizerName = event['organizer']!;
                  String imagePath = event['image']!;
                  return _buildEventCard(eventName, organizerName, imagePath);
                }).toList()
              : [const Text('No events added yet!')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  // Method to build individual event cards
  Widget _buildEventCard(
      String eventName, String organizerName, String imagePath) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            // Event detail screen can be implemented here
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(12)),
                  child: imagePath.isNotEmpty
                      ? Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                          height: 120,
                        )
                      : Image.network(
                          'https://via.placeholder.com/150',
                          fit: BoxFit.cover,
                          height: 120,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eventName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Organizer: $organizerName',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
