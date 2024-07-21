import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class EditStudentPage extends StatefulWidget {
  final String userId;

  EditStudentPage({required this.userId});

  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _subClassNameController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://${Config.baseUrl}/student/getStudentById/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _fullnameController.text = data['fullname'];
          _usernameController.text = data['username'];
          _passwordController.text = data['password'];
          _classNameController.text = data['classname'];
          _subClassNameController.text = data['subClassName'];
          isLoading = false;
        });
      } else {
        print('Failed to load student data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching student data: $e');
    }
  }

  Future<void> saveStudentData() async {
    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/student/updateStudent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': widget.userId,
          'fullname': _fullnameController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          'classname': _classNameController.text,
          'subClassName': _subClassNameController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student updated successfully')));
      } else {
        print('Failed to save student data: ${response.body}');
      }
    } catch (e) {
      print('Error saving student data: $e');
    }
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
                ],
              ),
            ),
    );
  }
}
