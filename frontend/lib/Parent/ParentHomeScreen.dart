import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/models/parentmodel.dart'; // Assuming you have a parent model

class ParentDashboard extends StatefulWidget {
  final Parent parent;
  final Children selectedChild;

  ParentDashboard({required this.parent, required this.selectedChild});

  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
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
          'studentId': widget.selectedChild.id,
          'fullname': widget.selectedChild.fullname,
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
          'studentId': widget.selectedChild.id,
          'fullName': widget.selectedChild.fullname,
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
        title: Text('ברוך הבא ${widget.parent.fullname}'),
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
                          subtitle: Text('ציון סופי: ${grade['finalGrade']}'),
                          children: [
                            ...assignmentGrades
                                .where((ag) =>
                                    ag['subjectName'] == grade['subjectName'])
                                .map((ag) {
                              return ListTile(
                                title: Text(ag['assignmentName']),
                                subtitle: Text('ציון: ${ag['grade']}'),
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
