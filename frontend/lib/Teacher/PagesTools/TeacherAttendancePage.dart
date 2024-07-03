import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/studenmodel.dart';

class TeacherAttendancePage extends StatefulWidget {
  final String userId;
  final String classname;
  final String subject;

  const TeacherAttendancePage(
      {Key? key,
      required this.userId,
      required this.classname,
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
  }

  Future<void> _fetchStudents() async {
    var url = Uri.parse(
        'http://10.100.102.3:3000/teacher/getstudents/${widget.classname}');
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

  // Future<void> _submitAttendance() async {
  //   List<Student> presentStudents =
  //       _students.where((student) => _attendance[student.id] == true).toList();

  //   var url = Uri.parse('http://10.100.102.3:3000/teacher/addatte');
  //   var response = await http.post(
  //     url,
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({
  //       'classname': widget.classname,
  //       'subjectname': widget.subject,
  //       'students': presentStudents.map((student) => student.id).toList(),
  //       'presdate': '20.4.2024', // Use actual present date
  //     }),
  //   );

  //   if (response.statusCode == 200) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Attendance added successfully')),
  //     );
  //     Navigator.pop(context); // Navigate back to the previous page
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error adding attendance')),
  //     );
  //   }
  // }
  Future<void> _submitAttendance() async {
    var url = Uri.parse('http://10.100.102.3:3000/teacher/addatte');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'classname': widget.classname,
        'subjectname': widget.subject,
        'students': _students
            .where((student) => _attendance[student.id] == true)
            .map((student) => {
                  'id': student.id,
                  'fullname': student.fullname,
                  'classname': student.classname,
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
        title:
            Text('Mark Attendance for ${widget.classname} - ${widget.subject}'),
      ),
      body: _isLoading
          ? const Center(child: const CircularProgressIndicator())
          : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                // Use null-coalescing to provide a default value of false
                return CheckboxListTile(
                  value: _attendance[student.id] ?? false,
                  onChanged: (bool? value) {
                    setState(() {
                      _attendance[student.id] = value ?? false;
                    });
                  },
                  title: Text(student.fullname),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitAttendance,
        child: const Icon(Icons.save),
      ),
    );
  }
}
