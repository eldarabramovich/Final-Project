// ignore: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'TeacherAssignmentSubmission.dart';
import 'package:frontend/config.dart';

class TeacherAddNewAssi extends StatefulWidget {
  final String userId;
  final String selectedClass;
  final String selectedSubject;

  const TeacherAddNewAssi({
    Key? key,
    required this.userId,
    required this.selectedClass,
    required this.selectedSubject,
  }) : super(key: key);

  @override
  State<TeacherAddNewAssi> createState() => _TeacherAddNewAssiState();
}

class _TeacherAddNewAssiState extends State<TeacherAddNewAssi> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _lastDateController = TextEditingController();
  File? _selectedFile;

  @override
  void initState() {
    super.initState();
  }

  void _navigateToSubmissions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherAssignmentSubmission(
          userId: widget.userId,
          selectedClass: widget.selectedClass,
          selectedSubject: widget.selectedSubject,
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
      print('Picked file: ${_selectedFile!.path}');
    } else {
      print('No file picked');
    }
  }

  Future<void> _submitAssignment() async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse('http://192.168.31.51:3000/teacher/AddAssignment');
      var request = http.MultipartRequest('POST', url);

      request.fields['classname'] = widget.selectedClass;
      request.fields['subjectname'] = widget.selectedSubject;
      request.fields['description'] = _descriptionController.text;
      request.fields['lastDate'] = _lastDateController.text;

      if (_selectedFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            _selectedFile!.path,
          ),
        );
      }

      var response = await request.send();

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
        actions: [
          TextButton(
            onPressed: _navigateToSubmissions,
            child: const Text(
              'ניהול הגשות',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
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
                onPressed: _pickFile,
                child: const Text('Pick File'),
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
