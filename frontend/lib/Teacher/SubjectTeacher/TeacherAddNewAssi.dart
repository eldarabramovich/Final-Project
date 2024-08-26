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
      var url = Uri.parse('http://${Config.baseUrl}/teacher/AddAssignment');
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
        backgroundColor: Colors.blue.shade800, // Use the color from your app
        title: const Text('הוספת משימה'),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'תיאור',
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  labelStyle: TextStyle(
                      color:
                          Colors.blue.shade800), // Use the color from your app
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .blue.shade800), // Use the color from your app
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'אנא הזן תיאור';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _lastDateController,
                decoration: InputDecoration(
                  labelText: 'תאריך אחרון',
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                  labelStyle: TextStyle(
                      color:
                          Colors.blue.shade800), // Use the color from your app
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors
                            .blue.shade800), // Use the color from your app
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'אנא הזן תאריך אחרון';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.attach_file),
                label: const Text('בחר קובץ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue.shade800, // Background color for button
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _submitAssignment,
                icon: const Icon(Icons.send),
                label: const Text('הגש משימה'),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue.shade800, // Background color for button
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
