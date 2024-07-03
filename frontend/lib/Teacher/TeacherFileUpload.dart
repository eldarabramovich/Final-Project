import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class UploadFilePage extends StatefulWidget {
  @override
  _UploadFilePageState createState() => _UploadFilePageState();
}

class _UploadFilePageState extends State<UploadFilePage> {
  File? _file;
  TextEditingController _teacherIdController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _response = '';

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _file = File(result.files.single.path!);
      });
      print('Picked file: ${_file!.path}');
    } else {
      print('No file picked');
    }
  }

  Future<void> _uploadFile() async {
    if (_file == null || _teacherIdController.text.isEmpty) {
      if (mounted) {
        setState(() {
          _response = 'Please select a file and enter a teacher ID';
        });
      }
      return;
    }

    print('Starting file upload');
    print('Teacher ID: ${_teacherIdController.text}');
    print('Description: ${_descriptionController.text}');
    print('File path: ${_file!.path}');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'http://172.20.10.2:3000/upload'), // Update with your IP address
    );

    request.fields['teacherId'] = _teacherIdController.text;
    request.fields['description'] = _descriptionController.text;
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _file!.path,
      ),
    );

    try {
      var response = await request.send();
      var responseBody = await http.Response.fromStream(response);

      if (mounted) {
        setState(() {
          if (response.statusCode == 200) {
            print('File uploaded successfully');
            _response = 'File uploaded successfully: ${responseBody.body}';
          } else {
            print('Error uploading file: ${responseBody.body}');
            _response = 'Error: ${responseBody.body}';
          }
        });
      }
    } catch (error) {
      if (mounted) {
        print('Error: $error');
        setState(() {
          _response = 'Error: $error';
        });
      }
    }
  }

  @override
  void dispose() {
    _teacherIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload File'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _teacherIdController,
              decoration: InputDecoration(labelText: 'Teacher ID'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload File'),
            ),
            SizedBox(height: 20),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
