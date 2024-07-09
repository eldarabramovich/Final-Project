/*

// ignore: file_names
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:frontend/models/studenmodel.dart';

class TeacherAttendancePage extends StatefulWidget {
  final String userId;
  final String selectedClass;
  final String subject;

  const TeacherAttendancePage(
      {Key? key,
      required this.userId,
      required this.selectedClass,
      required this.subject})
      : super(key: key);

  @override
  State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
  List<Student> _students = [];
  Map<String, bool> _attendance = {}; // Maps student ID to attendance status
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  } // Maps student ID to attendance status

  Future<void> _fetchStudents() async {
    var url = Uri.parse(
        'http://${Config.baseUrl}/teacher/getstudents/${widget.selectedClass}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> studentsJson = json.decode(response.body);
        setState(() {
          _students =
              studentsJson.map((json) => Student.fromFirestore(json)).toList();
          // Initialize attendance to false for all students.
          _attendance = {
            for (var student in _students) student.id: false,
          };
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

  Future<void> _submitAttendance() async {
    var url = Uri.parse('http://${Config.baseUrl}/teacher/addatte');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'classname': widget.selectedClass,
        'subjectname': widget.subject,
        'students': _students
            .where((student) => _attendance[student.id] == true)
            .map((student) => {
                  'id': student.id,
                  'fullname': student.fullname,
                  // add other properties as needed
                })
            .toList(),
        'presdate': DateTime.now().toIso8601String(), // use the current date
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance added successfully')),
      );
      Navigator.pop(context); // Navigate back to the previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding attendance')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark Attendance'),
      ),
      body: Column(
        children: [
          // Dropdowns for class and subject
          // ...

          // List of students with checkboxes
          Expanded(
            child: ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return CheckboxListTile(
                  value: _attendance[student.id],
                  onChanged: (bool? value) {
                    setState(() {
                      _attendance[student.id] = value!;
                    });
                  },
                  title: Text(student.fullname),
                );
              },
            ),
          ),

          // Submit button
          ElevatedButton(
            onPressed: _submitAttendance,
            child: Text('Submit Attendance'),
          ),
        ],
      ),
    );
  }
}

*/
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:frontend/models/studenmodel.dart'; // Ensure correct import

class TeacherAttendancePage extends StatefulWidget {
  final String userId;
  final String selectedClass;
  final String subject;

  const TeacherAttendancePage({
    Key? key,
    required this.userId,
    required this.selectedClass,
    required this.subject,
  }) : super(key: key);

  @override
  State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
  List<Student> _students = [];
  Map<String, bool> _attendance = {}; // Maps student ID to attendance status
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    var url = Uri.parse(
        'http://${Config.baseUrl}/teacher/getstudents/${widget.selectedClass}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> studentsJson = json.decode(response.body);
        setState(() {
          _students =
              studentsJson.map((json) => Student.fromFirestore(json)).toList();
          // Initialize attendance to false for all students.
          _attendance = {
            for (var student in _students) student.id: false,
          };
          _isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to fetch students. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to fetch students: $e';
      });
    }
  }

  Future<void> _submitAttendance() async {
    var url = Uri.parse('http://${Config.baseUrl}/teacher/addatte');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'classname': widget.selectedClass,
        'subjectname': widget.subject,
        'students': _students
            .where((student) => _attendance[student.id] == true)
            .map((student) => {
                  'id': student.id,
                  'fullname': student.fullname,
                  // add other properties as needed
                })
            .toList(),
        'presdate': DateTime.now().toIso8601String(), // use the current date
      }),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance added successfully')),
      );
      Navigator.pop(context); // Navigate back to the previous page
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding attendance')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'סימון נוכחות',
          style: TextStyle(fontFamily: 'Hebrew'),
        ),
        backgroundColor: Colors.blue, // Set app bar color to blue
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        ' ${widget.selectedClass}: כיתה',
                        style: TextStyle(fontSize: 18, fontFamily: 'Hebrew'),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '  ${widget.subject} :נושא',
                        style: TextStyle(fontSize: 18, fontFamily: 'Hebrew'),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 16),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _students.length,
                            itemBuilder: (context, index) {
                              final student = _students[index];
                              return CheckboxListTile(
                                value: _attendance[student.id],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _attendance[student.id] = value!;
                                  });
                                },
                                title: Text(
                                  student.fullname,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Hebrew',
                                  ),
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor:
                                    Colors.blue, // Customize checkbox color
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _submitAttendance,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // Set button background color to blue
                    ),
                    child: Text(
                      'שלח נוכחות',
                      style:
                          TextStyle(fontFamily: 'Hebrew', color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
