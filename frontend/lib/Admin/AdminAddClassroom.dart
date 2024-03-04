import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminAddClassroom extends StatefulWidget {
  @override
  _AdminAddClassroomState createState() => _AdminAddClassroomState();
}

class _AdminAddClassroomState extends State<AdminAddClassroom> {
  TextEditingController _classNameController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  List<String> _subjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Classroom'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _classNameController,
              decoration: InputDecoration(labelText: 'Classroom Name'),
            ),
            SizedBox(height: 16.0),
            Text('Subjects:'),
            TextField(
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
              onSubmitted: (value) {
                setState(() {
                  _subjects.add(value);
                  _subjectController.clear();
                });
              },
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_subjects[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _subjects.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Save the classroom details
                _saveClassroom();
                // Navigate back to previous screen
                Navigator.pop(context);
              },
              child: Text('Save Classroom'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveClassroom() async {
    String className = _classNameController.text;
    List<String> subjects = _subjects;

    var url = Uri.parse(
        'http://10.100.102.3:3000/admin/addclasubj'); // Replace with your actual endpoint
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'classname': className, 'subjects': subjects}),
    );

    if (response.statusCode == 200) {
      // Successfully added the class
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Class added successfully')));
    } else {
      // Error adding the class
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error adding class')));
    }
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _subjectController.dispose();
    super.dispose();
  }
}
