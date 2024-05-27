import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:user_repository/user_repository.dart';

class MaadWidget extends StatefulWidget {
  @override
  _MaadWidgetState createState() => _MaadWidgetState();
}

class _MaadWidgetState extends State<MaadWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  String _cause = 'Amenaza';
  bool _isSaving = false;

  // SQLite database
  late Database _database;

  // Initialize SQLite database
  void _initDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path + 'reports.db';

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Reports (id INTEGER PRIMARY KEY, description TEXT, cause TEXT)',
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _database.close();
    super.dispose();
  }

  // Save data to SQLite
  Future<void> _saveToSQLite(String description, String cause) async {
    await _database.insert(
      'Reports',
      {'description': description, 'cause': cause},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MAAD Report'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _descriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe your MAAD asocieted problem here', // Hint text
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _cause,
                onChanged: (String? newValue) {
                  setState(() {
                    _cause = newValue!;
                  });
                },
                items: <String>['Amenaza', 'Maltrato', 'Acoso', 'Discriminación']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Cause'),
              ),
              SizedBox(height: 16.0),
              Center( // Centering the button
                child: _isSaving
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isSaving = true;
                            });
                            String description = _descriptionController.text;
                            await _saveToSQLite(description, _cause);
                            await FirebaseUserRepo().sendReportToServer(description, _cause); // Call the function to send report
                            setState(() {
                              _isSaving = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Report saved and sent successfully'),
                              ),
                            );
                          }
                        },
                        child: Text('Save and Send'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
