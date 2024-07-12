/*

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class AdminAddTeacher extends StatefulWidget {
  const AdminAddTeacher({super.key});

  @override
  _AdminAddTeacher createState() => _AdminAddTeacher();
}

class _AdminAddTeacher extends State<AdminAddTeacher> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<Map<String, String>> _selectedClassesSubjects = [];
  String? _selectedClassHomeroom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Teacher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 17.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            const Text('Select Classes and Subjects:'),
            Wrap(
              children: List<Widget>.generate(
                _selectedClassesSubjects.length,
                (index) => Chip(
                  label: Text(
                      '${_selectedClassesSubjects[index]['classname']} - ${_selectedClassesSubjects[index]['subjectname']}'),
                  onDeleted: () {
                    setState(() {
                      _selectedClassesSubjects.removeAt(index);
                    });
                  },
                ),
              ).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                _showClassSubjectDialog();
              },
              child: const Text('Add Class and Subject'),
            ),
            const SizedBox(height: 16.0),
            const Text('Select Homeroom Class (Optional):'),
            DropdownButton<String>(
              value: _selectedClassHomeroom,
              hint: const Text('Select Homeroom Class'),
              items: _selectedClassesSubjects.map((classSubject) {
                return DropdownMenuItem<String>(
                  value: classSubject['classname'],
                  child: Text(classSubject['classname']!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedClassHomeroom = newValue;
                  // If a homeroom class is selected, clear selected class subjects
                  if (newValue != null) {
                    _selectedClassesSubjects.clear();
                  }
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveTeacher,
              child: const Text('Save Teacher'),
            ),
          ],
        ),
      ),
    );
  }

  void _showClassSubjectDialog() {
    TextEditingController classController = TextEditingController();
    TextEditingController subjectController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Class and Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: classController,
                decoration: const InputDecoration(labelText: 'Class Name'),
              ),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedClassesSubjects.add({
                    'classname': classController.text,
                    'subjectname': subjectController.text,
                  });
                  // If a class subject is added, clear the selected homeroom class
                  _selectedClassHomeroom = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveTeacher() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String fullName = _fullNameController.text;
    String email = _emailController.text;

    var url = Uri.parse(
        'http://${Config.baseUrl}/admin/CreateTeacher'); // Replace with your actual endpoint

    var requestBody = {
      'username': username,
      'password': password,
      'fullname': fullName,
      'email': email,
      'classesSubject':
          _selectedClassHomeroom == null ? _selectedClassesSubjects : null,
      'classHomeroom':
          _selectedClassHomeroom == null ? '' : _selectedClassHomeroom,
    };

    print(
        'Request body: $requestBody'); // Logging the request body for debugging

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // Teacher added successfully
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher added successfully')));
      Navigator.pop(context); // Navigate back to the previous screen
    } else {
      // Error adding teacher
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding teacher: ${response.body}')));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class AdminAddTeacher extends StatefulWidget {
  const AdminAddTeacher({super.key});

  @override
  _AdminAddTeacher createState() => _AdminAddTeacher();
}

class _AdminAddTeacher extends State<AdminAddTeacher> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<Map<String, String>> _selectedClassesSubjects = [];
  String? _selectedClassHomeroom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('הוספת מורה'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 17.0),
            Container(
              alignment: Alignment.centerRight,
              child: TextField(
                controller: _usernameController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'שם משתמש',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextField(
                controller: _passwordController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'סיסמה',
                  alignLabelWithHint: true,
                ),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.centerRight,
              child: TextField(
                controller: _fullNameController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'שם מלא',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextField(
                controller: _emailController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  labelText: 'אימייל',
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('בחר כיתות ונושאים:', textAlign: TextAlign.right),
            Wrap(
              children: List<Widget>.generate(
                _selectedClassesSubjects.length,
                (index) => Chip(
                  label: Text(
                      '${_selectedClassesSubjects[index]['classname']} - ${_selectedClassesSubjects[index]['subjectname']}'),
                  onDeleted: () {
                    setState(() {
                      _selectedClassesSubjects.removeAt(index);
                    });
                  },
                ),
              ).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                _showClassSubjectDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'הוסף כיתה ונושא',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('בחר כיתת מחנה (אופציונלי):',
                textAlign: TextAlign.right),
            DropdownButton<String>(
              value: _selectedClassHomeroom,
              hint: const Text('בחר כיתת מחנה'),
              isExpanded: true,
              items: _selectedClassesSubjects.map((classSubject) {
                return DropdownMenuItem<String>(
                  value: classSubject['classname'],
                  child: Text(classSubject['classname']!),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedClassHomeroom = newValue;
                  // If a homeroom class is selected, clear selected class subjects
                  if (newValue != null) {
                    _selectedClassesSubjects.clear();
                  }
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveTeacher,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                'שמור מורה',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClassSubjectDialog() {
    TextEditingController classController = TextEditingController();
    TextEditingController subjectController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('הוסף כיתה ונושא'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.centerRight,
                child: TextField(
                  controller: classController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(labelText: 'שם הכיתה'),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: TextField(
                  controller: subjectController,
                  textAlign: TextAlign.right,
                  decoration: const InputDecoration(labelText: 'נושא'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedClassesSubjects.add({
                    'classname': classController.text,
                    'subjectname': subjectController.text,
                  });
                  // If a class subject is added, clear the selected homeroom class
                  _selectedClassHomeroom = null;
                });
                Navigator.pop(context);
              },
              child: const Text('הוסף'),
            ),
          ],
        );
      },
    );
  }

  void _saveTeacher() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String fullName = _fullNameController.text;
    String email = _emailController.text;

    var url = Uri.parse(
        'http://${Config.baseUrl}/admin/CreateTeacher'); // Replace with your actual endpoint

    var requestBody = {
      'username': username,
      'password': password,
      'fullname': fullName,
      'email': email,
      'classesSubject':
          _selectedClassHomeroom == null ? _selectedClassesSubjects : null,
      'classHomeroom':
          _selectedClassHomeroom == null ? '' : _selectedClassHomeroom,
    };

    print(
        'Request body: $requestBody'); // Logging the request body for debugging

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      // Teacher added successfully
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('המורה נוסף בהצלחה')));
      Navigator.pop(context); // Navigate back to the previous screen
    } else {
      // Error adding teacher
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בהוספת המורה: ${response.body}')));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
