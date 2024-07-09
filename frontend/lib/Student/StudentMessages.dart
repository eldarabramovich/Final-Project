import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class StudentClassMessagesScreen extends StatefulWidget {
  final String userId;
  final String selectedClass;

  const StudentClassMessagesScreen(
      {Key? key, required this.userId, required this.selectedClass})
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
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      print('Fetching messages for class: ${widget.selectedClass}');
      var messagesResponse = await http.get(
        Uri.parse(
            'http://${Config.baseUrl}/student/getmess/${widget.selectedClass}'),
      );

      if (messagesResponse.statusCode == 200) {
        try {
          List<dynamic> messagesData = json.decode(messagesResponse.body);
          setState(() {
            _messages = List<String>.from(messagesData
                .map((message) => message['description'] as String));
            _isLoading = false;
          });
        } on FormatException catch (e) {
          print('Error parsing messages data: $e');
          _showError('Error parsing messages data');
        }
      } else {
        print('Failed to fetch messages: ${messagesResponse.statusCode}');
        print('Response body: ${messagesResponse.body}');
        _showError('Failed to fetch messages');
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
        title: const Text('Messages for Class'),
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
