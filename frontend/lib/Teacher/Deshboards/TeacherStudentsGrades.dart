import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/models/studenmodel.dart'; // Assuming you have a student model
import 'package:frontend/Teacher/Deshboards/TeacherStudentDashboard.dart'; // New page to display student details

class TeacherStudentsGrades extends StatefulWidget {
  final String selectedClass;

  TeacherStudentsGrades({required this.selectedClass});

  @override
  _TeacherStudentsGradesState createState() => _TeacherStudentsGradesState();
}

class _TeacherStudentsGradesState extends State<TeacherStudentsGrades> {
  List<Student> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    print('Students class ${widget.selectedClass}');
    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/teacher/getStudentsByClass'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'className': widget.selectedClass,
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> studentsJson = json.decode(response.body);
        setState(() {
          students =
              studentsJson.map((json) => Student.fromFirestore(json)).toList();
          isLoading = false;
        });
        print('Students fetched: $students');
      } else {
        Fluttertoast.showToast(msg: "Failed to load students");
        print('Failed to load students: ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load students: $e");
      print('Error fetching students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ברוך הבא'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];
                return ListTile(
                  title: Text(student.fullname),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TeacherStudentDashboard(
                          fullname: student.fullname,
                          id: student.id,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}