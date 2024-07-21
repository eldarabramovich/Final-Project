import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:frontend/models/studenmodel.dart';

class EditParentPage extends StatefulWidget {
  final String fullname;

  EditParentPage({required this.fullname});

  @override
  _EditParentPageState createState() => _EditParentPageState();
}

class _EditParentPageState extends State<EditParentPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<Student> _students = [];
  Map<String, bool> _selectedChildren = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParentData();
    _fetchStudents();
  }

  Future<void> fetchParentData() async {
    try {
      final response = await http.get(
        Uri.parse('http://${Config.baseUrl}/parent/getParentByFullname/${widget.fullname}'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _fullnameController.text = data['fullname'];
          _usernameController.text = data['username'];
          _passwordController.text = data['password'];
          _selectedChildren = {
            for (var child in data['children']) child['id']: true,
          };
          isLoading = false;
        });
      } else {
        print('Failed to load parent data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching parent data: $e');
    }
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
            for (var student in _students) student.id: _selectedChildren[student.id] ?? false,
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

  Future<void> saveParentData() async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, String>> selectedChildren = _students
        .where((student) => _selectedChildren[student.id] == true)
        .map((student) => {
              'id': student.id,
              'fullname': student.fullname,
            })
        .toList();

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/parent/updateParent'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'fullname': widget.fullname,
          'newUsername': _usernameController.text.isNotEmpty ? _usernameController.text : null,
          'newPassword': _passwordController.text.isNotEmpty ? _passwordController.text : null,
          'newFullname': _fullnameController.text.isNotEmpty ? _fullnameController.text : null,
          'children': selectedChildren,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Parent updated successfully')),
        );
        Navigator.pop(context); // Navigate back after saving
      } else {
        print('Failed to save parent data: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update parent')),
        );
      }
    } catch (e) {
      print('Error saving parent data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating parent')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteParent() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/parent/deleteParent'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{
          'fullname': widget.fullname,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Parent deleted successfully')),
        );
        Navigator.pop(context); // Navigate back after deletion
      } else {
        print('Failed to delete parent: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete parent')),
        );
      }
    } catch (e) {
      print('Error deleting parent: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting parent')),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Parent'),
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveParentData,
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: deleteParent,
                    child: Text('Delete'),
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}