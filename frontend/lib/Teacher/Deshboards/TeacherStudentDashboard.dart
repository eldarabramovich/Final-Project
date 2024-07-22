/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeacherStudentDashboard extends StatefulWidget {
  final String fullname;
  final String id;

  const TeacherStudentDashboard({required this.fullname, required this.id});

  @override
  _TeacherStudentDashboardState createState() =>
      _TeacherStudentDashboardState();
}

class _TeacherStudentDashboardState extends State<TeacherStudentDashboard> {
  List<Map<String, dynamic>> finalGrades = [];
  List<Map<String, dynamic>> assignmentGrades = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchFinalGrades();
    await fetchAssignmentGrades();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchFinalGrades() async {
    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/parent/finalGrades'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'studentId': widget.id,
          'fullname': widget.fullname,
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> gradesJson = json.decode(response.body);
        setState(() {
          finalGrades =
              gradesJson.map((json) => json as Map<String, dynamic>).toList();
        });
        print('Final grades fetched: $finalGrades');
      } else {
        Fluttertoast.showToast(msg: "Failed to load final grades");
        print('Failed to load final grades: ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load final grades: $e");
      print('Error fetching final grades: $e');
    }
  }

  Future<void> fetchAssignmentGrades() async {
    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/parent/assignmentGrades'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'studentId': widget.id,
          'fullName': widget.fullname,
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> gradesJson = json.decode(response.body);
        setState(() {
          assignmentGrades =
              gradesJson.map((json) => json as Map<String, dynamic>).toList();
        });
        print('Assignment grades fetched: $assignmentGrades');
      } else {
        Fluttertoast.showToast(msg: "Failed to load assignment grades");
        print('Failed to load assignment grades: ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load assignment grades: $e");
      print('Error fetching assignment grades: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Dashboard: ${widget.fullname}'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      ...finalGrades.map((grade) {
                        return ExpansionTile(
                          title: Text(grade['subjectName']),
                          subtitle: Text('Final Grade: ${grade['finalGrade']}'),
                          children: [
                            ...assignmentGrades
                                .where((ag) =>
                                    ag['subjectName'] == grade['subjectName'])
                                .map((ag) {
                              return ListTile(
                                title: Text(ag['assignmentName']),
                                subtitle: Text('Grade: ${ag['grade']}'),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TeacherStudentDashboard extends StatefulWidget {
  final String fullname;
  final String id;

  const TeacherStudentDashboard({required this.fullname, required this.id});

  @override
  _TeacherStudentDashboardState createState() =>
      _TeacherStudentDashboardState();
}

class _TeacherStudentDashboardState extends State<TeacherStudentDashboard> {
  List<Map<String, dynamic>> finalGrades = [];
  List<Map<String, dynamic>> assignmentGrades = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await fetchFinalGrades();
    await fetchAssignmentGrades();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchFinalGrades() async {
    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/parent/finalGrades'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'studentId': widget.id,
          'fullname': widget.fullname,
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> gradesJson = json.decode(response.body);
        setState(() {
          finalGrades =
              gradesJson.map((json) => json as Map<String, dynamic>).toList();
        });
        print('Final grades fetched: $finalGrades');
      } else {
        Fluttertoast.showToast(msg: "Failed to load final grades");
        print('Failed to load final grades: ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load final grades: $e");
      print('Error fetching final grades: $e');
    }
  }

  Future<void> fetchAssignmentGrades() async {
    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/parent/assignmentGrades'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'studentId': widget.id,
          'fullName': widget.fullname,
        }),
      );

      if (response.statusCode == 200) {
        List<dynamic> gradesJson = json.decode(response.body);
        setState(() {
          assignmentGrades =
              gradesJson.map((json) => json as Map<String, dynamic>).toList();
        });
        print('Assignment grades fetched: $assignmentGrades');
      } else {
        Fluttertoast.showToast(msg: "Failed to load assignment grades");
        print('Failed to load assignment grades: ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to load assignment grades: $e");
      print('Error fetching assignment grades: $e');
    }
  }

  double _calculateAverageGrade() {
    if (finalGrades.isEmpty) return 0.0;
    double total = 0.0;
    int count = 0;
    for (var grade in finalGrades) {
      double? finalGrade = double.tryParse(grade['finalGrade'].toString());
      if (finalGrade != null) {
        total += finalGrade;
        count++;
      }
    }
    return count > 0 ? total / count : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    double averageGrade = _calculateAverageGrade();

    return Scaffold(
      appBar: AppBar(
        title: Text('ציונים של: ${widget.fullname}',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.blue.shade800,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Display average grade at the top
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'ממוצע ציונים',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        averageGrade.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: finalGrades.length,
                    itemBuilder: (context, index) {
                      var grade = finalGrades[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ExpansionTile(
                          title: Text(
                            grade['subjectName'],
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text('Final Grade: ${grade['finalGrade']}'),
                          children: [
                            ...assignmentGrades
                                .where((ag) =>
                                    ag['subjectName'] == grade['subjectName'])
                                .map((ag) {
                              return ListTile(
                                title: Text(ag['assignmentName']),
                                subtitle: Text('Grade: ${ag['grade']}'),
                              );
                            }).toList(),
                          ],
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
