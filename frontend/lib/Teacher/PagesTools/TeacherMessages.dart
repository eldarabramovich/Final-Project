import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class TeacherSendMessage extends StatefulWidget {
  final String userId;
  final String selectedClass;

  const TeacherSendMessage(
      {Key? key, required this.userId, required this.selectedClass})
      : super(key: key);

  @override
  State<TeacherSendMessage> createState() => _TeacherSendMessageState();
}

class _TeacherSendMessageState extends State<TeacherSendMessage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse('http://${Config.baseUrl}/teacher/addmess');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'classname': widget.selectedClass,
          'description': _descriptionController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message sent successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message to Class'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Class: ${widget.selectedClass}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Message Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description for the message';
                  }
                  return null;
                },
                maxLines: 5, // Allow for multiple lines of input
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendMessage,
                child: Text('Send Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
