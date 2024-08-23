import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:frontend/models/studenmodel.dart';
import 'package:frontend/models/parentmodel.dart';

class StudentAttendancePage extends StatefulWidget {
  final Children selectedChild;

  StudentAttendancePage({required this.selectedChild});

  @override
  _StudentAttendancePageState createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  bool _isLoading = true;
  Map<String, Map<String, double>> _subjectAttendance = {};

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    var url = Uri.parse(
        'http://${Config.baseUrl}/teacher/getStudentAttendance/${widget.selectedChild.id}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> attendanceData =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        Map<String, Map<String, double>> subjectAttendance = {};

        // Extract subjects from the attendance data
        Set<String> subjects = attendanceData
            .map((record) => record['subjectname'].toString())
            .toSet();

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
            int lateClasses = subjectRecords
                .where((record) => record['status'] == 'Late')
                .length;

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

        setState(() {
          _subjectAttendance = subjectAttendance;
          _isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to fetch attendance data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch attendance data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Attendance'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _subjectAttendance.isEmpty
              ? Center(child: Text('No attendance data available.'))
              : ListView.builder(
                  itemCount: _subjectAttendance.length,
                  itemBuilder: (context, index) {
                    String subject = _subjectAttendance.keys.elementAt(index);
                    Map<String, double> percentages =
                        _subjectAttendance[subject]!;
                    return ListTile(
                      title: Text(subject),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Present: ${percentages['Present']?.toStringAsFixed(2)}%'),
                          Text(
                              'Absent: ${percentages['Absent']?.toStringAsFixed(2)}%'),
                          Text(
                              'Late: ${percentages['Late']?.toStringAsFixed(2)}%'),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
