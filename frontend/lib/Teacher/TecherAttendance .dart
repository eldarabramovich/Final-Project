import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/studenmodel.dart';

class TeacherAttendancePage extends StatefulWidget {
  final String userId;

  const TeacherAttendancePage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
}

class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
  String? _selectedClassname;
  String? _selectedSubject;
  List<Student> _students = [];
  Map<String, bool> _attendance = {}; // Maps student ID to attendance status

  Future<void> _fetchStudents(String classname) async {
    var url = Uri.parse('http://your-server-address/students/$classname');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> studentsJson = json.decode(response.body);
      setState(() {
        _students =
            studentsJson.map((json) => Student.fromFirestore(json)).toList();
        _attendance = {for (var student in _students) student.id: false};
      });
    } else {
      // Handle errors
    }
  }

  Future<void> _submitAttendance() async {
    var url = Uri.parse('http://your-server-address/attendance');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'classname': _selectedClassname,
        'subjectname': _selectedSubject,
        'students': _students
            .where((student) => _attendance[student.id] == true)
            .toList(),
        'presdate': DateTime.now().toIso8601String(), // Current date and time
      }),
    );

    if (response.statusCode == 200) {
      // Success
    } else {
      // Handle errors
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
