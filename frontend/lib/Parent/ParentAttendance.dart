/*

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
        title: Text('${widget.selectedChild.fullname} Attendance'),
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

*/
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
        backgroundColor: Colors.blue.shade900,
        title: Text(
          '${widget.selectedChild.fullname} נוכחות של ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Roboto',
            color: Colors.white,
          ),
        ),
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
          : _subjectAttendance.isEmpty
              ? Center(child: Text('אין נתוני נוכחות זמינים.'))
              : ListView.builder(
                  itemCount: _subjectAttendance.length,
                  itemBuilder: (context, index) {
                    String subject = _subjectAttendance.keys.elementAt(index);
                    Map<String, double> percentages =
                        _subjectAttendance[subject]!;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.blue.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              subject,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildAttendanceCircle('נוכח',
                                    percentages['Present']!, Colors.green),
                                _buildAttendanceCircle(
                                    'חסר', percentages['Absent']!, Colors.red),
                                _buildAttendanceCircle('איחור',
                                    percentages['Late']!, Colors.orange),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildAttendanceCircle(String label, double percentage, Color color) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.6), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${percentage.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontFamily: 'Roboto',
          ),
        ),
      ],
    );
  }
}
