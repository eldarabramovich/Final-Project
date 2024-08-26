import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
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
    final url =
        'http://${Config.baseUrl}/admin/getAssignmentsByClassAndSubject?classname=${widget.selectedClass}&subjectname=${widget.selectedSubject}';
    print('Fetching assignments from: $url');

    final response = await http.get(Uri.parse(url));

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> assignmentsJson = json.decode(response.body);
      setState(() {
        assignments =
            assignmentsJson.map((json) => Assignment.fromJson(json)).toList();
      });
    } else {
      Fluttertoast.showToast(msg: "נכשל לטעון את המשימות");
    }
  }

  Future<void> fetchSubmissions(String assignmentId) async {
    final url = 'http://${Config.baseUrl}/teacher/getSubmissions/$assignmentId';
    print('Fetching submissions from: $url');

    final response = await http.get(Uri.parse(url));

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> submissionsJson = json.decode(response.body);
      print('Parsed JSON: $submissionsJson');

      setState(() {
        submissions[assignmentId] =
            submissionsJson.map((json) => Submission.fromJson(json)).toList();
      });

      print('Submissions: ${submissions[assignmentId]}');
    } else {
      Fluttertoast.showToast(msg: "נכשל לטעון את ההגשות");
    }
  }

  Future<void> downloadSubmission(String submissionId, String fileUrl) async {
    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        print('אישור אחסון נדחה');
        Fluttertoast.showToast(msg: "יש צורך באישור אחסון כדי להוריד קבצים");
        return;
      }

      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/teacher/downloadSubmission'),
        body: jsonEncode({'submissionId': submissionId, 'fileUrl': fileUrl}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final filePath = await _writeToFile(response.bodyBytes, fileUrl);
        Fluttertoast.showToast(msg: "הקובץ הורד בהצלחה ל-$filePath");
      } else {
        print('שגיאה בהורדת הקובץ: ${response.statusCode}');
        Fluttertoast.showToast(
            msg: "שגיאה בהורדת הקובץ: ${response.statusCode}");
      }
    } catch (e) {
      print('שגיאה בזמן ההורדה: $e');
      Fluttertoast.showToast(msg: "שגיאה בהורדת הקובץ: $e");
    }
  }

  Future<String> _writeToFile(Uint8List data, String fileUrl) async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    if (directory == null) {
      throw Exception('אין גישה לתיקיית האחסון');
    }

    final filePath = path.join(directory.path, path.basename(fileUrl));
    final file = File(filePath);
    await file.writeAsBytes(data);
    return filePath;
  }

  Future<void> updateGrade(
      String submissionId, String fullName, String grade) async {
    final response = await http.post(
      Uri.parse('http://${Config.baseUrl}/teacher/updateSubmissionGrade'),
      body: jsonEncode(
          {'submissionId': submissionId, 'fullName': fullName, 'grade': grade}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: "הציון עודכן בהצלחה");
    } else {
      Fluttertoast.showToast(
          msg: "נכשל לעדכן את הציון: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 8),
            Text(
              'ניהול הגשות',
              style: GoogleFonts.notoSerifHebrew(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
          itemCount: assignments.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                assignments[index].description,
                style: GoogleFonts.notoSerifHebrew(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                if (submissions[assignments[index].id] == null)
                  ElevatedButton(
                    onPressed: () => fetchSubmissions(assignments[index].id),
                    child: Text('טעינת הגשות'),
                  )
                else
                  Column(
                    children:
                        submissions[assignments[index].id]!.map((submission) {
                      return ListTile(
                        title: Text(submission.fullName),
                        subtitle: Text(
                            'ציון: ${submission.grade.isEmpty ? 'ללא ציון' : submission.grade}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () => downloadSubmission(
                                  assignments[index].id, submission.fileUrl),
                            ),
                            IconButton(
                              icon: Icon(Icons.pin),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    String grade = '';
                                    return AlertDialog(
                                      title: Text('הזן ציון'),
                                      content: TextField(
                                        onChanged: (value) => grade = value,
                                        keyboardType: TextInputType.number,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('ביטול'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            updateGrade(assignments[index].id,
                                                submission.fullName, grade);
                                            Navigator.pop(context);
                                          },
                                          child: Text('שלח'),
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
      ),
    );
  }
}

class Submission {
  final String fileUrl;
  final String fullName;
  final DateTime submittedDate;
  final String grade;

  Submission({
    required this.fileUrl,
    required this.fullName,
    required this.submittedDate,
    required this.grade,
  });

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      fileUrl: json['fileUrl'],
      fullName: json['fullName'],
      submittedDate: DateTime.parse(json['submittedDate']),
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
      id: json['id'],
      description: json['description'],
    );
  }
}
