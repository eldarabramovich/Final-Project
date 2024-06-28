import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:file_picker/file_picker.dart';
import 'package:frontend/models/teachermodel.dart';

class TeacherAddNewAssi extends StatefulWidget {
  final String userId;
  const TeacherAddNewAssi({Key? key, required this.userId}) : super(key: key);
  @override
  State<TeacherAddNewAssi> createState() => _TeacherAddNewAssiState();
}

class _TeacherAddNewAssiState extends State<TeacherAddNewAssi> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _lastDateController = TextEditingController();
  Teacher? _teacher;
  String? _selectedClassname;
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    _fetchTeacherData();
  }

  Future<void> _fetchTeacherData() async {
    var url = Uri.parse('http://192.168.40.1:3000/teacher/${widget.userId}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _teacher = Teacher.fromFirestore(json.decode(response.body));
        if (_teacher!.classesHomeroom.isNotEmpty) {
          _selectedClassname = _teacher!.classesHomeroom.first.classname;
          _selectedSubject = _teacher!.classesHomeroom.first.subject;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch teacher data')),
      );
    }
  }

  Future<void> _submitAssignment() async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse('http://192.168.40.1:3000/teacher/addassi');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'classname': _selectedClassname,
          'subjectname': _selectedSubject,
          'description': _descriptionController.text,
          'lastDate': _lastDateController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Assignment added successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error adding assignment')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Assignment'),
      ),
      body: _teacher == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedClassname,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedClassname = newValue;
                          _selectedSubject = _teacher!.classesHomeroom
                              .firstWhere((cls) => cls.classname == newValue)
                              .subject;
                        });
                      },
                      items: _teacher!.classesHomeroom
                          .map((cls) => DropdownMenuItem<String>(
                                value: cls.classname,
                                child: Text(cls.classname),
                              ))
                          .toList(),
                      decoration: const InputDecoration(labelText: 'Class'),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _lastDateController,
                      decoration: const InputDecoration(labelText: 'Last Date'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a last date';
                        }
                        return null;
                      },
                    ),
                    ElevatedButton(
                      onPressed: _submitAssignment,
                      child: const Text('Submit Assignment'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
