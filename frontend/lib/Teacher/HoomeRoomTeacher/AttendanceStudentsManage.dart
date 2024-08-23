import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:frontend/models/studenmodel.dart';

class AttendanceStudentsManage extends StatefulWidget {
  final String userId;
  final String selectedClass;

  AttendanceStudentsManage({required this.userId, required this.selectedClass});

  @override
  _AttendanceStudentsManageState createState() =>
      _AttendanceStudentsManageState();
}

class _AttendanceStudentsManageState extends State<AttendanceStudentsManage> {
  List<Student> _students = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    var url = Uri.parse(
        'http://${Config.baseUrl}/teacher/getStudents/${widget.selectedClass}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _students = List<Student>.from(
            json
                .decode(response.body)
                .map((data) => Student.fromFirestore(data)),
          );
          _isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to fetch students. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch students: $e')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> fetchStudentAttendance(
      String studentId) async {
    var url = Uri.parse(
        'http://${Config.baseUrl}/teacher/getStudentAttendance/$studentId');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to fetch attendance data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch attendance data: $e')),
      );
      return [];
    }
  }

  Future<List<String>> extractSubjectsFromAttendance(
      List<Map<String, dynamic>> attendanceData) async {
    Set<String> subjects = attendanceData
        .map((record) => record['subjectname'].toString())
        .toSet();
    return subjects.toList();
  }

  void _showAttendanceForStudent(Student student) async {
    List<Map<String, dynamic>> attendanceData =
        await fetchStudentAttendance(student.id);

    Map<String, Map<String, double>> subjectAttendance = {};

    List<String> subjects = await extractSubjectsFromAttendance(attendanceData);

    for (String subject in subjects) {
      List<Map<String, dynamic>> subjectRecords = attendanceData
          .where((record) => record['subjectname'] == subject)
          .toList();

      int totalClasses = subjectRecords.length;
      if (totalClasses == 0) {
        subjectAttendance[subject] = {
          'Present': 0.0,
          'Absent': 0.0,
          'Late': 0.0
        };
      } else {
        int presentClasses = subjectRecords
            .where((record) => record['status'] == 'Present')
            .length;
        int absentClasses = subjectRecords
            .where((record) => record['status'] == 'Absent')
            .length;
        int lateClasses =
            subjectRecords.where((record) => record['status'] == 'Late').length;

        double presentPercentage = (presentClasses / totalClasses) * 100;
        double absentPercentage = (absentClasses / totalClasses) * 100;
        double latePercentage = (lateClasses / totalClasses) * 100;

        subjectAttendance[subject] = {
          'Present': presentPercentage,
          'Absent': absentPercentage,
          'Late': latePercentage
        };
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attendance for Student ${student.fullname}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: subjectAttendance.entries.map((entry) {
              String subject = entry.key;
              Map<String, double> percentages = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$subject:'),
                  Text(
                      'Present: ${percentages['Present']?.toStringAsFixed(2)}%'),
                  Text('Absent: ${percentages['Absent']?.toStringAsFixed(2)}%'),
                  Text('Late: ${percentages['Late']?.toStringAsFixed(2)}%'),
                  SizedBox(height: 8),
                ],
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Attendance for ${widget.selectedClass}'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return ListTile(
                  title: Text(student.fullname),
                  onTap: () => _showAttendanceForStudent(student),
                );
              },
            ),
    );
  }
}
