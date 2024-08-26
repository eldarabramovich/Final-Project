import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class EditAttendancePage extends StatefulWidget {
  final String attendanceId; // Change this to pass only the ID

  EditAttendancePage({required this.attendanceId});

  @override
  _EditAttendancePageState createState() => _EditAttendancePageState();
}

class _EditAttendancePageState extends State<EditAttendancePage> {
  late Map<String, String> _attendanceStatus;
  bool _isLoading = true; // Proper loading state management
  Map<String, dynamic>? attendanceData;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    try {
      var url = Uri.parse('http://${Config.baseUrl}/teacher/getAttendanceById');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': widget.attendanceId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          attendanceData = json.decode(response.body);
          _attendanceStatus = {
            for (var student in attendanceData!['students'])
              student['id']: student['status']
          };
          _isLoading = false; // Loading completed
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

  Future<void> _saveAttendance() async {
    try {
      var url = Uri.parse('http://${Config.baseUrl}/teacher/editAttendance');
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': widget.attendanceId,
          'students': _attendanceStatus.entries.map((entry) {
            return {
              'id': entry.key,
              'status': entry.value,
            };
          }).toList(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Attendance updated successfully')),
        );
        Navigator.pop(context); // Navigate back to the previous page
      } else {
        throw Exception(
            'Failed to save attendance. Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving attendance: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Attendance'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: attendanceData?['students']?.length ?? 0,
              itemBuilder: (context, index) {
                final student = attendanceData!['students'][index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(student['fullname']),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: const Text('Present',
                                      style: TextStyle(fontSize: 12)),
                                  value: 'Present',
                                  groupValue: _attendanceStatus[student['id']],
                                  onChanged: (value) {
                                    setState(() {
                                      _attendanceStatus[student['id']] = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: const Text('Absent',
                                      style: TextStyle(fontSize: 12)),
                                  value: 'Absent',
                                  groupValue: _attendanceStatus[student['id']],
                                  onChanged: (value) {
                                    setState(() {
                                      _attendanceStatus[student['id']] = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: const Text('Late',
                                      style: TextStyle(fontSize: 12)),
                                  value: 'Late',
                                  groupValue: _attendanceStatus[student['id']],
                                  onChanged: (value) {
                                    setState(() {
                                      _attendanceStatus[student['id']] = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAttendance,
        child: Icon(Icons.save),
        tooltip: 'Save Attendance',
      ),
    );
  }
}
