import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class TeacherSendMessage extends StatefulWidget {
  final String userId;
  final String selectedClass;

  const TeacherSendMessage({
    Key? key,
    required this.userId,
    required this.selectedClass,
  }) : super(key: key);

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
        title: Text('שלח הודעה לכיתה'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '  ${widget.selectedClass} : הודעה לכיתה ',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'תיאור ההודעה',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'יש להזין תיאור להודעה';
                    }
                    return null;
                  },
                  maxLines: 5, // Allow for multiple lines of input
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sendMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 168, 227, 255), // Set button color to baby blue
                  ),
                  child: Text('שלח הודעה'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
