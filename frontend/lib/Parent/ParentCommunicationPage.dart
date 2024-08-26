import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/config.dart';
import 'package:frontend/models/parentmodel.dart';

class ParentCommunicationPage extends StatefulWidget {
  final Parent parent;
  final Children selectedChild;

  const ParentCommunicationPage(
      {Key? key, required this.parent, required this.selectedChild})
      : super(key: key);

  @override
  _ParentCommunicationPageState createState() =>
      _ParentCommunicationPageState();
}

class _ParentCommunicationPageState extends State<ParentCommunicationPage> {
  String? _selectedClassName;
  String? _teacherId;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchClassNameAndTeacherId(widget.selectedChild.fullname);
  }

  Future<void> _fetchClassNameAndTeacherId(String childFullName) async {
    try {
      // Encode the child's full name to handle spaces and special characters
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/parent/getStudentByFullName'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'fullname': childFullName}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final studentData = json.decode(response.body);
        String className = studentData['subClassName'];

        setState(() {
          _selectedClassName = className;
        });
      } else {
        print('Failed to load student data: ${response.body}'); // Debug log
        Fluttertoast.showToast(msg: "Failed to load student data.");
      }
    } catch (e) {
      print('Error fetching student data: $e'); // Debug log
      Fluttertoast.showToast(msg: "Error fetching student data: $e");
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty || widget.selectedChild == null) {
      Fluttertoast.showToast(
          msg: "Message cannot be empty or child not selected.");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/parent/sendMessageToTeacher'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'parentName': widget.parent.fullname,
          'message': _messageController.text,
          'studentClass': _selectedClassName,
        }),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Message sent successfully.");
        _messageController.clear();
      } else {
        Fluttertoast.showToast(msg: "Failed to send message.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Communicate with Teacher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_teacherId != null)
              Text('Communicating with Teacher ID: $_teacherId',
                  style: TextStyle(fontSize: 18)),
            if (widget.selectedChild.fullname != null &&
                _selectedClassName != null)
              Text(
                  'Child: ${widget.selectedChild.fullname}, Class: $_selectedClassName',
                  style: TextStyle(fontSize: 16)),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(labelText: 'Enter your message'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendMessage,
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
