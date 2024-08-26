import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/config.dart';

class TeacherMessagesPage extends StatefulWidget {
  final String teacherClass; // The class the teacher is teaching

  const TeacherMessagesPage({Key? key, required this.teacherClass})
      : super(key: key);

  @override
  _TeacherMessagesPageState createState() => _TeacherMessagesPageState();
}

class _TeacherMessagesPageState extends State<TeacherMessagesPage> {
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessagesForClass();
  }

  Future<void> _fetchMessagesForClass() async {
    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/teacher/getMessagesForClass'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'className': widget.teacherClass,
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> messagesJson = json.decode(response.body);
        setState(() {
          messages =
              messagesJson.map((json) => Message.fromJson(json)).toList();
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to load messages.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching messages: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages for ${widget.teacherClass}'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return ListTile(
            title: Text(message.parentName),
            subtitle: Text(message.message),
            trailing: Text(message.timestamp.toString()),
          );
        },
      ),
    );
  }
}

class Message {
  final String parentName;
  final String message;
  final String studentClass;
  final DateTime timestamp;

  Message({
    required this.parentName,
    required this.message,
    required this.studentClass,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      parentName: json['parentName'],
      message: json['message'],
      studentClass: json['studentClass'],
      timestamp: DateTime.parse(
          json['timestamp']), // Correctly parse the string to DateTime
    );
  }
}
