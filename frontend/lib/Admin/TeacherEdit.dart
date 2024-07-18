import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class EditTeacherPage extends StatefulWidget {
  final String userId;

  EditTeacherPage({required this.userId});

  @override
  _EditTeacherPageState createState() => _EditTeacherPageState();
}

class _EditTeacherPageState extends State<EditTeacherPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _classHomeroomController = TextEditingController();
  final TextEditingController _classesSubjectController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeacherData();
  }

  Future<void> fetchTeacherData() async {
    try {
      final response = await http.get(
        Uri.parse('http://${Config.baseUrl}/teacher/getTeacherById/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _fullnameController.text = data['fullname'];
          _usernameController.text = data['username'];
          _passwordController.text = data['password'];
          _emailController.text = data['email'];
          _classHomeroomController.text = data['classHomeroom'].join(', ');
          _classesSubjectController.text = data['classesSubject']
              .map((subject) => '${subject['classname']} - ${subject['subjectname']}')
              .join(', ');
          isLoading = false;
        });
      } else {
        print('Failed to load teacher data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching teacher data: $e');
    }
  }

  Future<void> saveTeacherData() async {
    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/teacher/updateTeacher'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': widget.userId,
          'fullname': _fullnameController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          'email': _emailController.text,
          'classHomeroom': _classHomeroomController.text.split(',').map((name) => name.trim()).toList(),
          'classesSubject': _classesSubjectController.text.split(',').map((subject) {
            var parts = subject.split('-');
            return {
              'classname': parts[0].trim(),
              'subjectname': parts[1].trim(),
            };
          }).toList(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Teacher updated successfully')));
      } else {
        print('Failed to save teacher data: ${response.body}');
      }
    } catch (e) {
      print('Error saving teacher data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Teacher'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(
                    controller: _fullnameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _classHomeroomController,
                    decoration: InputDecoration(labelText: 'Class Homeroom (comma separated)'),
                  ),
                  TextField(
                    controller: _classesSubjectController,
                    decoration: InputDecoration(labelText: 'Classes and Subjects (comma separated)'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveTeacherData,
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}