import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeacherClassDetailPage extends StatefulWidget {
  final String userId;
  final String selectedClass;
  final String selectedSubject;

  TeacherClassDetailPage({
    Key? key,
    required this.userId,
    required this.selectedClass,
    required this.selectedSubject,
  }) : super(key: key);

  @override
  _TeacherClassDetailPageState createState() => _TeacherClassDetailPageState();
}

class _TeacherClassDetailPageState extends State<TeacherClassDetailPage> {
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final response = await http.get(
      Uri.parse(
          'http://${Config.baseUrl}/teacher/getStudentsBySubject?subClassName=${widget.selectedClass}&subjectname=${widget.selectedSubject}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> studentsJson = json.decode(response.body);
      setState(() {
        students =
            studentsJson.map((json) => json as Map<String, dynamic>).toList();
      });
    } else {
      Fluttertoast.showToast(msg: "Failed to load students");
    }
  }

  Future<void> saveGrade(int index) async {
    final student = students[index];
    final response = await http.post(
      Uri.parse('http://${Config.baseUrl}/teacher/updateFinalGrade'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'subClassName': widget.selectedClass,
        'subjectName': widget.selectedSubject,
        'fullName': student['fullname'],
        'finalGrade': student['finalGrade']
      }),
    );

    if (response.statusCode != 200) {
      Fluttertoast.showToast(
          msg: "Failed to save grade for ${student['fullname']}");
    } else {
      Fluttertoast.showToast(
          msg: "Grade saved successfully for ${student['fullname']}");
    }
  }

  Future<void> saveAllGrades() async {
    for (var i = 0; i < students.length; i++) {
      await saveGrade(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.selectedClass} - ${widget.selectedSubject}',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: saveAllGrades,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          final grade = student['finalGrade'] ?? '';

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  student['fullname'],
                  textAlign: TextAlign.right,
                ),
              ),
              trailing: SizedBox(
                width: 200,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: grade.isEmpty ? 'ציון' : grade,
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        onChanged: (value) {
                          students[index]['finalGrade'] = value;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () => saveGrade(index),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
