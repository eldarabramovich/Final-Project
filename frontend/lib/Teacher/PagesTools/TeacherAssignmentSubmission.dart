import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/config.dart';

class TeacherAssignmentSubmission extends StatefulWidget {
  final String userId;
  final String selectedClass;
  final String selectedSubject;

  const TeacherAssignmentSubmission({
    Key? key,
    required this.userId,
    required this.selectedClass,
    required this.selectedSubject,
  }) : super(key: key);

  @override
  _TeacherAssignmentSubmissionState createState() =>
      _TeacherAssignmentSubmissionState();
}

class _TeacherAssignmentSubmissionState
    extends State<TeacherAssignmentSubmission> {
  List<Assignment> assignments = [];
  Map<String, List<Submission>> submissions = {};

  @override
  void initState() {
    super.initState();
    fetchAssignments();
  }

  Future<void> fetchAssignments() async {
    final response = await http.get(
      Uri.parse(
          'http://${Config.baseUrl}/teacher/getAssigments/assignments?class=${widget.selectedClass}&subject=${widget.selectedSubject}'),
    );

    if (response.statusCode == 200) {
      List<dynamic> assignmentsJson = json.decode(response.body);
      setState(() {
        assignments =
            assignmentsJson.map((json) => Assignment.fromJson(json)).toList();
      });
    } else {
      Fluttertoast.showToast(msg: "Failed to load assignments");
    }
  }

  Future<void> fetchSubmissions(String assignmentId) async {
    final response = await http.get(
      Uri.parse('http://${Config.baseUrl}/teacher/submissions/$assignmentId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> submissionsJson = json.decode(response.body);
      setState(() {
        submissions[assignmentId] =
            submissionsJson.map((json) => Submission.fromJson(json)).toList();
      });
    } else {
      Fluttertoast.showToast(msg: "Failed to load submissions");
    }
  }

  Future<void> downloadSubmission(String fileUrl) async {
    // Implement file download logic here
    Fluttertoast.showToast(msg: "Downloading file...");
  }

  Future<void> gradeSubmission(String submissionId, String grade) async {
    final response = await http.post(
      Uri.parse('http://${Config.baseUrl}/teacher/grade-submission'),
      body: {'submissionId': submissionId, 'grade': grade},
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "Grade submitted successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to submit grade");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage submissions'),
      ),
      body: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(assignments[index].description),
            children: [
              if (submissions[assignments[index].id] == null)
                ElevatedButton(
                  onPressed: () => fetchSubmissions(assignments[index].id),
                  child: Text('Load Submissions'),
                )
              else
                Column(
                  children:
                      submissions[assignments[index].id]!.map((submission) {
                    return ListTile(
                      title: Text(submission.studentName),
                      subtitle:
                          Text('Grade: ${submission.grade ?? 'Not graded'}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.download),
                            onPressed: () =>
                                downloadSubmission(submission.fileUrl),
                          ),
                          IconButton(
                            icon: Icon(Icons.grade),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  String grade = '';
                                  return AlertDialog(
                                    title: Text('Enter Grade'),
                                    content: TextField(
                                      onChanged: (value) => grade = value,
                                      keyboardType: TextInputType.number,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          gradeSubmission(submission.id, grade);
                                          Navigator.pop(context);
                                        },
                                        child: Text('Submit'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          );
        },
      ),
    );
  }
}

class Submission {
  final String id;
  final String studentName;
  final String fileUrl;
  final String? grade;

  Submission({
    required this.id,
    required this.studentName,
    required this.fileUrl,
    this.grade,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'] ?? '',
      studentName: json['studentName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      grade: json['grade'],
    );
  }
}

class Assignment {
  final String id;
  final String description;

  Assignment({
    required this.id,
    required this.description,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['classname'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
