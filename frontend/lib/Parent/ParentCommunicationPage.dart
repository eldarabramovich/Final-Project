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
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/parent/getStudentByFullName'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'fullname': childFullName}),
      );

      if (response.statusCode == 200) {
        final studentData = json.decode(response.body);
        String className = studentData['subClassName'];

        setState(() {
          _selectedClassName = className;
        });
      } else {
        Fluttertoast.showToast(msg: "Failed to load student data.");
      }
    } catch (e) {
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
        title: Text(
          'הודעה למחנך הכיתה',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_teacherId != null)
              Text(
                'Teacher ID: $_teacherId',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.right,
              ),
            if (widget.selectedChild.fullname != null &&
                _selectedClassName != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'תלמיד: ${widget.selectedChild.fullname}\n כיתה: $_selectedClassName',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.right,
                ),
              ),
            SizedBox(height: 20),
            TextField(
              controller: _messageController,
              maxLines: 5,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                labelText: 'הזן את ההודעה שלך',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: _sendMessage,
                icon: Icon(Icons.send),
                label: Text('שלח'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
