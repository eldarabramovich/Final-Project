import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class TeacherFiles extends StatefulWidget {
  @override
  _TeacherFilesState createState() => _TeacherFilesState();
}

class _TeacherFilesState extends State<TeacherFiles> {
  String? _selectedClass; // Initialize with null
  File? _selectedFile; // Initialize with null

  final List<String> _classOptions = [
    'Class A',
    'Class B',
    'Class C'
  ]; // Example class options

  void _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'העלת מסמך חדש',
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedClass,
              onChanged: (newValue) {
                setState(() {
                  _selectedClass = newValue;
                });
              },
              items: _classOptions.map((String classOption) {
                return DropdownMenuItem<String>(
                  value: classOption,
                  child: Text(classOption),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText: 'בחירת כיתה',
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                ),
                onPressed: _selectFile,
                child: Text('בחירת מסמך'),
              ),
            ),
            SizedBox(height: 20),
            _selectedFile != null
                ? Text('File selected: ${_selectedFile!.path}')
                : Container(),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // Text color
                    ),
                    onPressed: () {
                      // Handle file upload logic
                      // Here you can upload the selected file using _selectedFile
                    },
                    child: Text(
                      'שליחת מסמך ',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
