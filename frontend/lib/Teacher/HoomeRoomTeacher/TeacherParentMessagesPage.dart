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
        title: Text(
          ' ${widget.teacherClass} :הורים של כיתה ',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Merienda',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User icon
                CircleAvatar(
                  backgroundImage: AssetImage('assets/icons/usericon.png'),
                ),
                SizedBox(width: 10),
                // Message bubble
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.parentName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          message.message,
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${message.timestamp.day}/${message.timestamp.month}/${message.timestamp.year} ${message.timestamp.hour}:${message.timestamp.minute}',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
