import 'package:flutter/material.dart';

class BudgetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController budgetController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Budget'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set Event Budget',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Budget Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to save or update the budget
              },
              child: Text('Save Budget'),
            ),
          ],
        ),
      ),
    );
  }
}
