import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(NoteApp());
}

class NoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: NoteScreen(),
    );
  }
}

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  List<Note> notes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 173, 141, 157),
        title: Text('Notes'),
      ),
      body: Container(
        color: Color.fromARGB(255, 173, 141, 157), // Background color
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return Card(
              color: _randomPastelColor(),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Text(
                        notes[index].heading,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(notes[index].content),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => _editNote(index),
                          icon: Icon(Icons.edit, size: 20),
                        ),
                        IconButton(
                          onPressed: () => _deleteNote(index),
                          icon: Icon(Icons.delete, size: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNote() async {
    final result = await showDialog<Note>(
      context: context,
      builder: (context) => AddNoteDialog(),
    );

    if (result != null) {
      setState(() {
        notes.add(result);
      });
    }
  }

  void _editNote(int index) async {
    final result = await showDialog<Note>(
      context: context,
      builder: (context) => EditNoteDialog(note: notes[index]),
    );

    if (result != null) {
      setState(() {
        notes[index] = result;
      });
    }
  }

  void _deleteNote(int index) {
    setState(() {
      notes.removeAt(index);
    });
  }
}

class Note {
  String heading;
  String content;

  Note({
    required this.heading,
    required this.content,
  });
}

class AddNoteDialog extends StatelessWidget {
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _headingController,
            decoration: InputDecoration(labelText: 'Heading'),
          ),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(labelText: 'Content'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final heading = _headingController.text.trim();
            final content = _contentController.text.trim();
            if (heading.isNotEmpty && content.isNotEmpty) {
              Navigator.of(context).pop(
                Note(
                  heading: heading,
                  content: content,
                ),
              );
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

class EditNoteDialog extends StatelessWidget {
  final Note note;
  final TextEditingController _headingController;
  final TextEditingController _contentController;

  EditNoteDialog({required this.note})
      : _headingController = TextEditingController(text: note.heading),
        _contentController = TextEditingController(text: note.content);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _headingController,
            decoration: InputDecoration(labelText: 'Heading'),
          ),
          TextField(
            controller: _contentController,
            decoration: InputDecoration(labelText: 'Content'),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final heading = _headingController.text.trim();
            final content = _contentController.text.trim();
            if (heading.isNotEmpty && content.isNotEmpty) {
              Navigator.of(context).pop(
                Note(
                  heading: heading,
                  content: content,
                ),
              );
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}

Color _randomPastelColor() {
  final random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(150) + 100,
    random.nextInt(150) + 100,
    random.nextInt(150) + 100,
  );
}
