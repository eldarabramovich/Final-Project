/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:frontend/models/studenmodel.dart';

class AdminAddParent extends StatefulWidget {
  const AdminAddParent({super.key});

  @override
  _AdminAddParentState createState() => _AdminAddParentState();
}

class _AdminAddParentState extends State<AdminAddParent> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  List<Student> _students = [];
  Map<String, bool> _selectedChildren = {};

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    var url = Uri.parse('http://${Config.baseUrl}/admin/getAllStudents');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> studentsJson = json.decode(response.body);
        setState(() {
          _students = studentsJson
              .map((json) => Student(
                    id: json['id'],
                    fullname: json['fullname'],
                    classname: '',
                    subClassName: '',
                  ))
              .toList();
          _selectedChildren = {
            for (var student in _students) student.id: false,
          };
        });
      } else {
        throw Exception('Failed to fetch students');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch students: $e')),
        );
      }
    }
  }

  Future<void> _addParent() async {
    List<Map<String, String>> selectedChildren = _students
        .where((student) => _selectedChildren[student.id] == true)
        .map((student) => {
              'id': student.id,
              'fullname': student.fullname,
            })
        .toList();

    var url = Uri.parse('http://${Config.baseUrl}/admin/addParent');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': _usernameController.text,
        'password': _passwordController.text,
        'fullname': _fullnameController.text,
        'children': selectedChildren,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parent added successfully')),
      );
      Navigator.pop(context); // Navigate back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add parent: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Parent'),
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
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fullnameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 20),
            const Text('Select Children:'),
            _students.isEmpty
                ? const CircularProgressIndicator()
                : Column(
                    children: _students.map((student) {
                      return CheckboxListTile(
                        title: Text(student.fullname),
                        value: _selectedChildren[student.id],
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedChildren[student.id] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addParent,
              child: const Text('Save Parent'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    super.dispose();
  }
}

*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:frontend/models/studenmodel.dart';

class AdminAddParent extends StatefulWidget {
  const AdminAddParent({Key? key}) : super(key: key);

  @override
  _AdminAddParentState createState() => _AdminAddParentState();
}

class _AdminAddParentState extends State<AdminAddParent> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  List<Student> _students = [];
  Map<String, bool> _selectedChildren = {};

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    var url = Uri.parse('http://${Config.baseUrl}/admin/getAllStudents');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> studentsJson = json.decode(response.body);
        setState(() {
          _students = studentsJson
              .map((json) => Student(
                    id: json['id'],
                    fullname: json['fullname'],
                    classname: '',
                    subClassName: '',
                  ))
              .toList();
          _selectedChildren = {
            for (var student in _students) student.id: false,
          };
        });
      } else {
        throw Exception('Failed to fetch students');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch students: $e')),
        );
      }
    }
  }

  Future<void> _addParent() async {
    List<Map<String, String>> selectedChildren = _students
        .where((student) => _selectedChildren[student.id] == true)
        .map((student) => {
              'id': student.id,
              'fullname': student.fullname,
            })
        .toList();

    var url = Uri.parse('http://${Config.baseUrl}/admin/addParent');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': _usernameController.text,
        'password': _passwordController.text,
        'fullname': _fullnameController.text,
        'children': selectedChildren,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Parent added successfully')),
      );
      Navigator.pop(context); // Navigate back to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add parent: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'הוספת הורה',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Hebrew', // Example for Hebrew font
            fontSize: 18.0, // Adjust as needed
          ),
        ),
        backgroundColor: Colors.blue.shade800, // Example color
        centerTitle: true, // Center title if needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 17.0),
            TextFormField(
              controller: _usernameController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(labelText: 'שם משתמש'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              textAlign: TextAlign.right,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'סיסמה'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _fullnameController,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(labelText: 'שם מלא'),
            ),
            const SizedBox(height: 20),
            const Text('בחר תלמידים:'),
            _students.isEmpty
                ? const CircularProgressIndicator()
                : Column(
                    children: _students.map((student) {
                      return CheckboxListTile(
                        title: Text(
                          student.fullname,
                          textAlign: TextAlign.right,
                        ),
                        value: _selectedChildren[student.id],
                        onChanged: (bool? value) {
                          setState(() {
                            _selectedChildren[student.id] = value ?? false;
                          });
                        },
                      );
                    }).toList(),
                  ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
              ),
              onPressed: _addParent,
              child: const Text('שמור הורה'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    super.dispose();
  }
}
