import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/teachermodel.dart'; // Update with correct path if necessary

class TeacherSendMessage extends StatefulWidget {
  final String userId;

  const TeacherSendMessage({Key? key, required this.userId}) : super(key: key);

  @override
  State<TeacherSendMessage> createState() => _TeacherSendMessageState();
}

class _TeacherSendMessageState extends State<TeacherSendMessage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  Teacher? _teacher;
  String? _selectedClassname;

  @override
  void initState() {
    super.initState();
    _fetchTeacherData();
  }

  Future<void> _fetchTeacherData() async {
    var url = Uri.parse('http://yourapi.com/teacher/${widget.userId}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _teacher = Teacher.fromFirestore(json.decode(response.body));
        if (_teacher!.classes.isNotEmpty) {
          _selectedClassname = _teacher!.classes.first.classname;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch teacher data')),
      );
    }
  }

  Future<void> _sendMessage() async {
    if (_formKey.currentState!.validate()) {
      // TODO: Replace with your actual endpoint
      var url = Uri.parse('http://yourapi.com/teacher/sendmessage');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'classname': _selectedClassname,
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
      body: _teacher == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedClassname,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedClassname = newValue;
                        });
                      },
                      items: _teacher!.classes
                          .map((cls) => DropdownMenuItem<String>(
                                value: cls.classname,
                                child: Text(cls.classname),
                              ))
                          .toList(),
                      decoration: InputDecoration(labelText: 'Class'),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration:
                          InputDecoration(labelText: 'Message Description'),
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
