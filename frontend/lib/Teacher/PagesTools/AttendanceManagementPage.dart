import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:frontend/Teacher/PagesTools/AddAttendancePage.dart';
import 'package:frontend/Teacher/PagesTools/EditAttendancePage.dart';

class AttendanceManagementPage extends StatefulWidget {
  final String selectedClass;
  final String subject;
  final String userId;

  const AttendanceManagementPage({
    Key? key,
    required this.selectedClass,
    required this.subject,
    required this.userId,
  }) : super(key: key);

  @override
  _AttendanceManagementPageState createState() =>
      _AttendanceManagementPageState();
}

class _AttendanceManagementPageState extends State<AttendanceManagementPage> {
  List<dynamic> _attendanceRecords = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceRecords();
  }

  Future<void> _fetchAttendanceRecords() async {
    var url = Uri.parse('http://${Config.baseUrl}/teacher/getAttendanceRecords');
    try {
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'classname': widget.selectedClass,
          'subject': widget.subject,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _attendanceRecords = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to fetch attendance records. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch attendance records: $e')),
      );
    }
  }

  void _navigateToAddAttendance() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddAttendancePage(
              selectedClass: widget.selectedClass, subject: widget.subject)),
    );
  }

  void _navigateToEditAttendance(String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditAttendancePage(attendanceId: id)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Management'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _attendanceRecords.length,
                    itemBuilder: (context, index) {
                      final record = _attendanceRecords[index];
                      return ExpansionTile(
                        title: Text('Date: ${record['presdate']}'),
                        trailing: ElevatedButton(
                          onPressed: () =>
                              _navigateToEditAttendance(record['id']),
                          child: Text('Edit'),
                        ),
                        children: [
                          ...record['students'].map<Widget>((student) {
                            return ListTile(
                              title: Text(student['fullname']),
                              subtitle: Text('Status: ${student['status']}'),
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _navigateToAddAttendance,
                  child: Text('Add Attendance'),
                ),
              ],
            ),
    );
  }
}