import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/models/parentmodel.dart'; // Assuming you have a parent model

class ParentChildGrade extends StatefulWidget {
  final Parent parent;
  final Children selectedChild;

  ParentChildGrade({required this.parent, required this.selectedChild});

  @override
  _ParentChildGradeState createState() => _ParentChildGradeState();
}

class _ParentChildGradeState extends State<ParentChildGrade> {
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

  double calculateAverageGrade() {
    if (finalGrades.isEmpty) return 0;
    double sum = finalGrades.fold(0, (previousValue, grade) {
      double finalGrade = double.tryParse(grade['finalGrade'].toString()) ?? 0;
      return previousValue + finalGrade;
    });
    return sum / finalGrades.length;
  }

  @override
  Widget build(BuildContext context) {
    double avgGrade = calculateAverageGrade();
    return Scaffold(
      appBar: AppBar(
        title: Text('ברוך הבא ${widget.parent.fullname}'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Circle displaying average grade
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue.shade800,
                    child: Text(
                      avgGrade.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: finalGrades.length,
                    itemBuilder: (context, index) {
                      var grade = finalGrades[index];
                      bool hasFinalGrade = grade['finalGrade'] != null;
                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          leading: Icon(
                            hasFinalGrade ? Icons.check_circle : Icons.error,
                            color: hasFinalGrade ? Colors.green : Colors.red,
                          ),
                          title: Text(grade['subjectName']),
                          subtitle: Text('ציון סופי: ${grade['finalGrade']}'),
                          trailing: Icon(Icons.expand_more),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(grade['subjectName']),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: assignmentGrades
                                        .where((ag) =>
                                            ag['subjectName'] ==
                                            grade['subjectName'])
                                        .map((ag) => ListTile(
                                              title: Text(ag['assignmentName']),
                                              subtitle:
                                                  Text('ציון: ${ag['grade']}'),
                                            ))
                                        .toList(),
                                  ),
                                );
                              },
                            );
                          },
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
