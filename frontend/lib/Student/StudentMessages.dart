import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentClassMessagesScreen extends StatefulWidget {
  final String userId;

  const StudentClassMessagesScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _StudentClassMessagesScreenState createState() =>
      _StudentClassMessagesScreenState();
}

class _StudentClassMessagesScreenState
    extends State<StudentClassMessagesScreen> {
  List<String> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudentClassAndMessages();
  }

  Future<void> _fetchStudentClassAndMessages() async {
    try {
      // Fetch the student's class using the student ID
      var studentClassResponse = await http.get(
        Uri.parse('http://10.0.0.14:3000/student/getstudent/${widget.userId}'),
      );

      if (studentClassResponse.statusCode == 200) {
        try {
          var studentData = json.decode(studentClassResponse.body);
          var studentClass = studentData['classname'];

          // Fetch messages for the student's class
          var messagesResponse = await http.get(
            Uri.parse('http://10.0.0.14:3000/student/getmess/${studentClass}'),
          );

          if (messagesResponse.statusCode == 200) {
            try {
              List<dynamic> messagesData = json.decode(messagesResponse.body);
              setState(() {
                _messages = List<String>.from(messagesData
                    .map((message) => message['description'] as String));
                _isLoading = false;
              });
            } on FormatException {
              _showError('Error parsing messages data');
            }
          } else {
            _showError('Failed to fetch messages');
          }
        } on FormatException {
          _showError('Error parsing student class data');
        }
      } else {
        _showError('Failed to fetch student class');
      }
    } catch (e, stacktrace) {
      print('An error occurred: $e');
      print('Stacktrace: $stacktrace');
      _showError('An error occurred while fetching data');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'הודעות לכיתה',
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _messages.isEmpty
              ? const Center(child: Text('No messages found'))
              : ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_messages[index]),
                    );
                  },
                ),
    );
  }
}
