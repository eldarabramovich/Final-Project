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
    var url = Uri.parse('http://10.0.0.22:3000/teacher/${widget.userId}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _teacher = Teacher.fromFirestore(json.decode(response.body));
        if (_teacher!.classes.isNotEmpty) {
          _selectedClassname = _teacher!.classes.first.classname;
          _selectedSubject = _teacher!.classes.first.subject;
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
      var url = Uri.parse('http://10.0.0.22:3000/teacher/addassi');
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
        title: Text(
          'מטלה חדשה',
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: _teacher == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 25.0),
                    DropdownButtonFormField<String>(
                      value: _selectedClassname,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedClassname = newValue;
                          _selectedSubject = _teacher!.classes
                              .firstWhere((cls) => cls.classname == newValue)
                              .subject;
                        });
                      },
                      items: _teacher!.classes
                          .map((cls) => DropdownMenuItem<String>(
                                value: cls.classname,
                                child: Text(cls.classname),
                              ))
                          .toList(),
                      decoration: InputDecoration(
                        labelText: 'כיתה',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 17.0),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'הסבר',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 17.0),
                    TextFormField(
                      controller: _lastDateController,
                      decoration: InputDecoration(
                        labelText: 'Last Date',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a last date';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue, // Text color
                      ),
                      onPressed: _submitAssignment,
                      child: Text(
                        'שלח משימה',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
