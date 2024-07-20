import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class EditTeacherPage extends StatefulWidget {
  @override
  _EditTeacherPageState createState() => _EditTeacherPageState();
}

class _EditTeacherPageState extends State<EditTeacherPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _classHomeroomController =
      TextEditingController();
  final TextEditingController _classesSubjectController =
      TextEditingController();

  bool isLoading = false;

  Future<void> saveTeacherData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/admin/updateTeacher'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'fullname': _fullnameController.text,
          'newUsername': _usernameController.text,
          'newPassword': _passwordController.text,
          'newEmail': _emailController.text,
          'newClassHomeroom': _classHomeroomController.text.trim().isEmpty
              ? null
              : _classHomeroomController.text.trim(),
          'newClassesSubject': _classesSubjectController.text.trim().isEmpty
              ? []
              : _classesSubjectController.text.split(',').map((subject) {
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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update teacher')));
      }
    } catch (e) {
      print('Error saving teacher data: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating teacher')));
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteTeacher() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/admin/deleteTeacher'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'fullname': _fullnameController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Teacher deleted successfully')));
        Navigator.pop(context); // Navigate back after deletion
      } else {
        print('Failed to delete teacher: ${response.body}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to delete teacher')));
      }
    } catch (e) {
      print('Error deleting teacher: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting teacher')));
    }

    setState(() {
      isLoading = false;
    });
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
                    decoration: InputDecoration(
                        labelText: 'Class Homeroom (comma separated)'),
                  ),
                  TextField(
                    controller: _classesSubjectController,
                    decoration: InputDecoration(
                        labelText:
                            'Classes and Subjects (format: classname-subjectname, separated by commas)'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveTeacherData,
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: deleteTeacher,
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ],
              ),
            ),
    );
  }
}
