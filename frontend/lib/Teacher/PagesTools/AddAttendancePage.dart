import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:frontend/models/studenmodel.dart';

class AddAttendancePage extends StatefulWidget {
  final String selectedClass;
  final String subject;

  const AddAttendancePage({Key? key, required this.selectedClass, required this.subject}) : super(key: key);

  @override
  _AddAttendancePageState createState() => _AddAttendancePageState();
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  List<Student> _students = [];
  Map<String, String> _attendance = {}; // Maps student ID to attendance status
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    var url = Uri.parse('http://${Config.baseUrl}/teacher/getstudents/${widget.selectedClass}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> studentsJson = json.decode(response.body);
        setState(() {
          _students = studentsJson.map((json) => Student.fromFirestore(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch students. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch students: $e')),
      );
    }
  }
Future<void> _submitAttendance() async {
  var url = Uri.parse('http://${Config.baseUrl}/teacher/addAttendance');

  try {
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'classname': widget.selectedClass,
        'subjectname': widget.subject,
        'students': _students.map((student) {
          return {
            'id': student.id,
            'fullname': student.fullname,
            'status': _attendance[student.id] ?? 'Absent', // Default to 'Absent'
          };
        }).toList(),
        'presdate': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance added successfully')),
      );
      Navigator.pop(context);
    } else {
      // Log the response body for debugging
      print('Error adding attendance: ${response.statusCode} - ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding attendance: ${response.body}')),
      );
    }
  } catch (e) {
    // Log the full error for debugging
    print('Exception occurred while adding attendance: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exception occurred: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Attendance'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      return Column(
                        children: [
                          Text(student.fullname),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Present'),
                                  value: 'Present',
                                  groupValue: _attendance[student.id],
                                  onChanged: (value) {
                                    setState(() {
                                      _attendance[student.id] = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Absent'),
                                  value: 'Absent',
                                  groupValue: _attendance[student.id],
                                  onChanged: (value) {
                                    setState(() {
                                      _attendance[student.id] = value!;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text('Late'),
                                  value: 'Late',
                                  groupValue: _attendance[student.id],
                                  onChanged: (value) {
                                    setState(() {
                                      _attendance[student.id] = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitAttendance,
                  child: Text('Submit Attendance'),
                ),
              ],
            ),
    );
  }
}
