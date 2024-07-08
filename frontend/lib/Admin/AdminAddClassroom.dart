import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class AdminAddClassroom extends StatefulWidget {
  const AdminAddClassroom({super.key});

  @override
  _AdminAddClassroomState createState() => _AdminAddClassroomState();
}

class _AdminAddClassroomState extends State<AdminAddClassroom> {
  final TextEditingController _classLetterController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final List<String> _subjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'הוספת כיתה חדשה',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 17.0),
            TextField(
              controller: _classLetterController,
              decoration: const InputDecoration(labelText: 'Class Letter'),
            ),
            const SizedBox(height: 16.0),
            const Text('Subjects:'),
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
              onSubmitted: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    _subjects.add(value);
                    _subjectController.clear();
                  }
                });
              },
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _subjects.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_subjects[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
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
              onPressed: _saveClassroom,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
              ),
              child: const Text('שמור כיתה'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveClassroom() async {
    String classLetter = _classLetterController.text;
    List<String> subjects = _subjects;

    var url = Uri.parse(
        'http://${Config.baseUrl}/admin/CreateClass'); // Replace with your actual endpoint
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'classLetter': classLetter,
        'Subjects': subjects,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully added the class
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class added successfully')),
      );
      // Navigate back to the home screen
      Navigator.pop(context);
    } else {
      // Error adding the class
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error adding class')));
    }
  }

  @override
  void dispose() {
    _classLetterController.dispose();
    _subjectController.dispose();
    super.dispose();
  }
}
