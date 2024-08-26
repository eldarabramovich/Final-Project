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
          SnackBar(content: Text('ההודעה נשלחה בהצלחה')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בשליחת ההודעה')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('שלח הודעה לכיתה'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'כיתה: ${widget.selectedClass}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'תיאור ההודעה',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                          prefixIcon:
                              Icon(Icons.message, color: Colors.blueAccent),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'אנא הכנס תיאור להודעה';
                          }
                          return null;
                        },
                        maxLines: null, // Allow the field to expand vertically
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: _sendMessage,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent, // Text color
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'שלח הודעה',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
