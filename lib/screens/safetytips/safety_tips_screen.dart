import 'package:flutter/material.dart';

class SafetyTipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Tips on Campus'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color.fromRGBO(80, 225, 130, 1),
          onPressed: () {
            Navigator.pop(context); // go back to the previous screen
          },
          padding: EdgeInsets.zero,
          splashRadius: 24,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Safety Tips on Campus',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Always be aware of your surroundings.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              '2. Avoid walking alone at night.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8.0),
            Text(
              '3. Use campus security services.',
              style: TextStyle(fontSize: 16),
            ),
            // Add more safety tips here
          ],
        ),
      ),
    );
  }
}
