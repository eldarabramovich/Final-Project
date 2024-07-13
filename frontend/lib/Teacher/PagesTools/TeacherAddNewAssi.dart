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
        title: Text('הוספת מטלה'),
        backgroundColor: Colors.blue,
        actions: [
          TextButton(
            onPressed: _navigateToSubmissions,
            child: Text(
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
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'תיאור המטלה',
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'יש להזין תיאור למטלה';
                    }
                    return null;
                  },
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: _lastDateController,
                  decoration: InputDecoration(
                    labelText: 'תאריך אחרון להגשה',
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'יש להזין תאריך אחרון להגשה';
                    }
                    return null;
                  },
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _pickFile,
                  icon: Icon(Icons.attach_file),
                  label: Text('בחר קובץ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent, // baby blue color
                    padding: EdgeInsets.symmetric(horizontal: 24),
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _submitAssignment,
                  child: Text('שלח מטלה'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent, // baby blue color
                    padding: EdgeInsets.symmetric(horizontal: 48),
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
