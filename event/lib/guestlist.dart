import 'package:flutter/material.dart';

class GuestListScreen extends StatefulWidget {
  @override
  _GuestListScreenState createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  // List to store guests
  List<Map<String, dynamic>> guests = [];

  // Search Controller
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  // Method to filter guests based on search query
  List<Map<String, dynamic>> get filteredGuests {
    if (searchQuery.isEmpty) {
      return guests;
    } else {
      return guests
          .where((guest) =>
              guest['name'].toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  // Method to open dialog and add a new guest
  void _openAddGuestDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        return AlertDialog(
          title: Text('Add Guest'),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Guest Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    guests.add({
                      'name': nameController.text,
                      'status': 'pending',
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Guest Manager'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search guests',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            SizedBox(height: 16),
            // Guest List
            Expanded(
              child: ListView.builder(
                itemCount: filteredGuests.length,
                itemBuilder: (context, index) {
                  final guest = filteredGuests[index];
                  return _buildGuestTile(guest);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddGuestDialog,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  // Method to build each guest tile
  Widget _buildGuestTile(Map<String, dynamic> guest) {
    Color tileColor = guest['status'] == 'confirmed'
        ? Colors.blue.shade100
        : Colors.grey.shade300;
    IconData statusIcon =
        guest['status'] == 'confirmed' ? Icons.check_circle : Icons.access_time;
    Color iconColor =
        guest['status'] == 'confirmed' ? Colors.blue : Colors.grey;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: tileColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        title: Text(guest['name']),
        trailing: Icon(statusIcon, color: iconColor),
        onTap: () {
          setState(() {
            // Toggle the status of the guest when tapped
            guest['status'] =
                guest['status'] == 'pending' ? 'confirmed' : 'pending';
          });
        },
      ),
    );
  }
}
