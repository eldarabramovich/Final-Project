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

  String? _selectedClass;
  String? _selectedSubject;
  String? _selectedClassHomeroom;

  final List<String> _validClasses = [
    'A1',
    'A2',
    'A3',
    'A4',
    'A5',
    'B1',
    'B2',
    'B3',
    'B4',
    'B5',
    'C1',
    'C2',
    'C3',
    'C4',
    'C5',
    'D1',
    'D2',
    'D3',
    'D4',
    'D5'
  ];
  final List<String> _validSubjects = [
    'Math',
    'Science',
    'History',
    'English',
    'Arabic'
  ];

  String? errorMessage;

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
              items: _validClasses.map((String className) {
                return DropdownMenuItem<String>(
                  value: className,
                  child: Text(className),
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
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Class and Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _selectedClass,
                hint: const Text('Select Class'),
                items: _validClasses.map((String className) {
                  return DropdownMenuItem<String>(
                    value: className,
                    child: Text(className),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedClass = newValue;
                  });
                },
              ),
              DropdownButton<String>(
                value: _selectedSubject,
                hint: const Text('Select Subject'),
                items: _validSubjects.map((String subjectName) {
                  return DropdownMenuItem<String>(
                    value: subjectName,
                    child: Text(subjectName),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedSubject = newValue;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_selectedClass != null && _selectedSubject != null) {
                  setState(() {
                    _selectedClassesSubjects.add({
                      'classname': _selectedClass!,
                      'subjectname': _selectedSubject!,
                    });
                    _selectedClassHomeroom =
                        null; // Clear homeroom if subject selected
                  });
                  Navigator.pop(context);
                } else {
                  setState(() {
                    errorMessage = 'Please select both class and subject.';
                  });
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveTeacher() async {
    // Reset the error message
    setState(() {
      errorMessage = null;
    });

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String fullName = _fullNameController.text.trim();
    String email = _emailController.text.trim();

    if (_validateInputs(username, password, fullName, email)) {
      var url = Uri.parse(
          'http://${Config.baseUrl}/admin/CreateTeacher'); // Replace with your actual endpoint

      var requestBody = {
        'username': username,
        'password': password,
        'fullname': fullName,
        'email': email,
        'classesSubject': (_selectedClassHomeroom?.isEmpty ?? true)
            ? _selectedClassesSubjects
            : null,
        'classHomeroom': _selectedClassHomeroom ?? '',
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
        setState(() {
          errorMessage = 'Error adding teacher: ${response.body}';
        });
      }
    }
  }

  bool _validateInputs(
      String username, String password, String fullName, String email) {
    if (username.isEmpty ||
        password.isEmpty ||
        fullName.isEmpty ||
        email.isEmpty) {
      setState(() {
        errorMessage = 'Please fill out all required fields.';
      });
      return false;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        errorMessage = 'Please enter a valid email address.';
      });
      return false;
    }

    // Ensure at least one class-subject pair or homeroom class is selected
    if (_selectedClassesSubjects.isEmpty &&
        (_selectedClassHomeroom?.isEmpty ?? true)) {
      setState(() {
        errorMessage =
            'Please select at least one class and subject, or a homeroom class.';
      });
      return false;
    }

    if ((_selectedClassHomeroom?.isNotEmpty ?? false) &&
        _selectedClassesSubjects.isNotEmpty) {
      setState(() {
        errorMessage =
            'Teacher cannot be both a homeroom teacher and a subject teacher.';
      });
      return false;
    }

    return true;
  }

  bool _isValidEmail(String email) {
    // Basic email validation
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
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
