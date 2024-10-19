import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => MyWidgetState();
}

class MyWidgetState extends State<MyWidget> {
  List<Map<String, String>> tasks = [];

  void _addTask(String title, String description) {
    setState(() {
      tasks.add({
        'title': title,
        'description': description,
        'completed': 'false',
      });
    });
  }

  void _navigateToAddTaskScreen() async {
    final newTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
    if (newTask != null) {
      _addTask(newTask['title']!, newTask['description']!);
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index]['completed'] =
          (tasks[index]['completed'] == 'true') ? 'false' : 'true';
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _deleteAllTasks() {
    setState(() {
      tasks.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TO DO APP"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      tasks[index]['title']!,
                      style: TextStyle(
                        color: tasks[index]['completed'] == 'true'
                            ? Colors.blue
                            : Colors.black,
                      ),
                    ),
                    subtitle: Text(tasks[index]['description']!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.verified_rounded,
                            color: tasks[index]['completed'] == 'true'
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          onPressed: () => _toggleTaskCompletion(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _navigateToAddTaskScreen,
                  child: Text('ADD'),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _deleteAllTasks,
                  child: Text('Delete All'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Date: ${_selectedDate!.toLocal()}',
                  ),
                ),
                TextButton(
                  child: Text('Choose Date'),
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null && pickedDate != _selectedDate) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedTime == null
                        ? 'No Time Chosen!'
                        : 'Time: ${_selectedTime!.format(context)}',
                  ),
                ),
                TextButton(
                  child: Text('Choose Time'),
                  onPressed: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null && pickedTime != _selectedTime) {
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newTask = {
                  'title': _titleController.text,
                  'description': _descriptionController.text,
                  'date': _selectedDate.toString(),
                  'time': _selectedTime.toString(),
                };
                Navigator.pop(context, newTask);
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
