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
            'לא הצלחתי להביא את רשימת התלמידים. קוד סטטוס: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('לא הצלחתי להביא את רשימת התלמידים: $e')),
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
            'לא הצלחתי להביא את נתוני הנוכחות. קוד סטטוס: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('לא הצלחתי להביא את נתוני הנוכחות: $e')),
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
        subjectAttendance[subject] = {'נוכח': 0.0, 'נעדר': 0.0, 'מאחר': 0.0};
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
          'נוכח': presentPercentage,
          'נעדר': absentPercentage,
          'מאחר': latePercentage
        };
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('נוכחות לתלמיד ${student.fullname}'),
          content: SingleChildScrollView(
            child: Column(
              children: subjectAttendance.entries.map((entry) {
                String subject = entry.key;
                Map<String, double> percentages = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$subject:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildAttendanceCircle(
                              'נוכח', percentages['נוכח'] ?? 0, Colors.green),
                          _buildAttendanceCircle(
                              'נעדר', percentages['נעדר'] ?? 0, Colors.red),
                          _buildAttendanceCircle(
                              'מאחר', percentages['מאחר'] ?? 0, Colors.orange),
                        ],
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('סגור', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAttendanceCircle(String label, double percentage, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[200],
            border: Border.all(
              color: color,
              width: 4,
            ),
          ),
          child: Center(
            child: Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ניהול נוכחות ל-${widget.selectedClass}',
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(student.fullname[0]),
                      backgroundColor:
                          Colors.blueAccent, // Consistent color for the avatar
                      foregroundColor: Colors.white,
                    ),
                    title: Text(student.fullname),
                    onTap: () => _showAttendanceForStudent(student),
                  ),
                );
              },
            ),
    );
  }
}
