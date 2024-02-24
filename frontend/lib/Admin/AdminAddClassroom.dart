import 'package:flutter/material.dart';

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

  void _saveClassroom() {
    // Save the classroom details
    String className = _classNameController.text;
    List<String> subjects = _subjects;

    // You can now use these values to save the classroom
    // For example, you can call an API or save to a database
    // Don't forget to validate the data before saving
  }

  @override
  void dispose() {
    _classNameController.dispose();
    _subjectController.dispose();
    super.dispose();
  }
}