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
  final TextEditingController _homeroomClassController = TextEditingController();
  final List<Map<String, String>> _selectedClassesSubjects = [];

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
            TextField(
              controller: _homeroomClassController,
              decoration: const InputDecoration(labelText: 'Homeroom Class'),
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
                  _homeroomClassController.clear();
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
    String homeroomClass = _homeroomClassController.text;

    var url = Uri.parse(
        'http://${Config.baseUrl}/admin/CreateTeacher'); // Replace with your actual endpoint

    var requestBody = {
      'username': username,
      'password': password,
      'fullname': fullName,
      'email': email,
      'classesSubject': _selectedClassesSubjects.isNotEmpty ? _selectedClassesSubjects : null,
      'classHomeroom': homeroomClass.isNotEmpty ? homeroomClass : null,
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
    _homeroomClassController.dispose();
    super.dispose();
  }
}
