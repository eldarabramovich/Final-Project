import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/config.dart';

class StudentGrade extends StatefulWidget {
  final String studentName;

  StudentGrade({required this.studentName});

  @override
  _StudentGradeState createState() => _StudentGradeState();
}

class _StudentGradeState extends State<StudentGrade> {
  List<Map<String, dynamic>> grades = [];

  @override
  void initState() {
    super.initState();
    fetchStudentGrades();
  }

  Future<void> fetchStudentGrades() async {
    final response = await http.get(
      Uri.parse(
          'http://${Config.baseUrl}/student/grades?studentName=${widget.studentName}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> gradesJson = json.decode(response.body);
      setState(() {
        grades =
            gradesJson.map((json) => json as Map<String, dynamic>).toList();
      });
    } else {
      Fluttertoast.showToast(msg: "Failed to load grades");
    }
  }

  // Calculate the average grade
  double get averageGrade {
    if (grades.isEmpty) return 0.0;
    final total = grades.fold<int>(
        0, (sum, grade) => sum + int.parse(grade['finalGrade'] as String));
    return total / grades.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('הציונים שלי'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.blue.shade800,
            child: Column(
              children: [
                Text(
                  'ממוצע',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  averageGrade.toStringAsFixed(2),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final grade = grades[index];
                final gradeColor = int.parse(grade['finalGrade']) > 56
                    ? Colors.green
                    : Colors.red;

                return Card(
                  color: Colors.blue.shade50,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ' ${grade['subjectName']}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'ציון: ${grade['finalGrade']}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: gradeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
