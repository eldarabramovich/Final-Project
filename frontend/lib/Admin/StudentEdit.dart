import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class EditStudentPage extends StatefulWidget {
  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _subClassNameController = TextEditingController();

  bool isLoading = false;

  Future<void> saveStudentData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/admin/updateStudent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'fullname': _fullnameController.text,
          'newUsername': _usernameController.text,
          'newPassword': _passwordController.text,
          'newClassname': _classNameController.text.isEmpty
              ? null
              : _classNameController.text,
          'newSubClassName': _subClassNameController.text.isEmpty
              ? null
              : _subClassNameController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student updated successfully')));
      } else {
        print('Failed to save student data: ${response.body}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update student')));
      }
    } catch (e) {
      print('Error saving student data: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating student')));
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteStudent() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/admin/deleteStudent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'fullname': _fullnameController.text,
          'classname': _classNameController.text,
          'subClassName': _subClassNameController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student deleted successfully')));
        Navigator.pop(context); // Navigate back after deletion
      } else {
        print('Failed to delete student: ${response.body}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to delete student')));
      }
    } catch (e) {
      print('Error deleting student: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting student')));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
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
                    controller: _classNameController,
                    decoration: InputDecoration(labelText: 'Class Name'),
                  ),
                  TextField(
                    controller: _subClassNameController,
                    decoration: InputDecoration(labelText: 'Sub Class Name'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveStudentData,
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: deleteStudent,
                    child: Text('Delete'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
    );
  }
}
