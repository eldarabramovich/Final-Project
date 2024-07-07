// ignore: file_names
import 'package:flutter/material.dart';
import 'package:frontend/models/teachermodel.dart';
import 'package:frontend/Teacher/TeacherAttendancePage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class TeacherClassSubjectSelectionPage extends StatefulWidget {
  final String userId;

  const TeacherClassSubjectSelectionPage({Key? key, required this.userId})
      : super(key: key);

  @override
  State<TeacherClassSubjectSelectionPage> createState() =>
      _TeacherClassSubjectSelectionPageState();
}

class _TeacherClassSubjectSelectionPageState
    extends State<TeacherClassSubjectSelectionPage> {
  Teacher? _teacher;
  String? _selectedClassname;
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    _fetchTeacherData();
  }

  Future<void> _fetchTeacherData() async {
    var url = Uri.parse('http://10.0.0.22:3000/teacher/${widget.userId}');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _teacher = Teacher.fromFirestore(json.decode(response.body));
        if (_teacher!.classes.isNotEmpty) {
          _selectedClassname = _teacher!.classes.first.classname;
          _selectedSubject = _teacher!.classes.first.subject;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch teacher data')),
      );
    }
  }

  void _navigateToAttendancePage() {
    if (_selectedClassname != null && _selectedSubject != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeacherAttendancePage(
            userId: widget.userId,
            classname: _selectedClassname!,
            subject: _selectedSubject!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Class and Subject'),
      ),
      body: _teacher == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedClassname,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedClassname = newValue;
                      // Update _selectedSubject based on the selected class
                    });
                  },
                  items: _teacher!.classes
                      .map((cls) => DropdownMenuItem<String>(
                            value: cls.classname,
                            child: Text(cls.classname),
                          ))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Class'),
                ),
                // Display selected subject
                Text('Subject: $_selectedSubject'),
                ElevatedButton(
                  onPressed: _navigateToAttendancePage,
                  child: const Text('Continue to Attendance'),
                ),
              ],
            ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:frontend/models/studenmodel.dart';

// class TeacherAttendancePage extends StatefulWidget {
//   final String userId;

//   const TeacherAttendancePage({Key? key, required this.userId})
//       : super(key: key);

//   @override
//   State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
// }

// class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
//   String? _selectedClassname;
//   String? _selectedSubject;
//   List<Student> _students = [];
//   Map<String, bool> _attendance = {}; // Maps student ID to attendance status

//   Future<void> _fetchStudents(String classname) async {
//     var url = Uri.parse('http://your-server-address/students/$classname');
//     var response = await http.get(url);

//     if (response.statusCode == 200) {
//       List<dynamic> studentsJson = json.decode(response.body);
//       setState(() {
//         _students =
//             studentsJson.map((json) => Student.fromFirestore(json)).toList();
//         _attendance = {for (var student in _students) student.id: false};
//       });
//     } else {
//       // Handle errors
//     }
//   }

//   Future<void> _submitAttendance() async {
//     var url = Uri.parse('http://your-server-address/attendance');
//     var response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'classname': _selectedClassname,
//         'subjectname': _selectedSubject,
//         'students': _students
//             .where((student) => _attendance[student.id] == true)
//             .toList(),
//         'presdate': DateTime.now().toIso8601String(), // Current date and time
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Success
//     } else {
//       // Handle errors
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mark Attendance'),
//       ),
//       body: Column(
//         children: [
//           // Dropdowns for class and subject
//           // ...

//           // List of students with checkboxes
//           Expanded(
//             child: ListView.builder(
//               itemCount: _students.length,
//               itemBuilder: (context, index) {
//                 final student = _students[index];
//                 return CheckboxListTile(
//                   value: _attendance[student.id],
//                   onChanged: (bool? value) {
//                     setState(() {
//                       _attendance[student.id] = value!;
//                     });
//                   },
//                   title: Text(student.fullname),
//                 );
//               },
//             ),
//           ),

//           // Submit button
//           ElevatedButton(
//             onPressed: _submitAttendance,
//             child: Text('Submit Attendance'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:frontend/models/studenmodel.dart';

// class TeacherAttendancePage extends StatefulWidget {
//   final String userId;

//   const TeacherAttendancePage({Key? key, required this.userId})
//       : super(key: key);

//   @override
//   State<TeacherAttendancePage> createState() => _TeacherAttendancePageState();
// }

// class _TeacherAttendancePageState extends State<TeacherAttendancePage> {
//   String? _selectedClassname;
//   String? _selectedSubject;
//   List<Student> _students = [];
//   Map<String, bool> _attendance = {}; // Maps student ID to attendance status

//   Future<void> _fetchStudents(String classname) async {
//     var url = Uri.parse('http://your-server-address/students/$classname');
//     var response = await http.get(url);

//     if (response.statusCode == 200) {
//       List<dynamic> studentsJson = json.decode(response.body);
//       setState(() {
//         _students =
//             studentsJson.map((json) => Student.fromFirestore(json)).toList();
//         _attendance = {for (var student in _students) student.id: false};
//       });
//     } else {
//       // Handle errors
//     }
//   }

//   Future<void> _submitAttendance() async {
//     var url = Uri.parse('http://your-server-address/attendance');
//     var response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'classname': _selectedClassname,
//         'subjectname': _selectedSubject,
//         'students': _students
//             .where((student) => _attendance[student.id] == true)
//             .toList(),
//         'presdate': DateTime.now().toIso8601String(), // Current date and time
//       }),
//     );

//     if (response.statusCode == 200) {
//       // Success
//     } else {
//       // Handle errors
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mark Attendance'),
//       ),
//       body: Column(
//         children: [
//           // Dropdowns for class and subject
//           // ...

//           // List of students with checkboxes
//           Expanded(
//             child: ListView.builder(
//               itemCount: _students.length,
//               itemBuilder: (context, index) {
//                 final student = _students[index];
//                 return CheckboxListTile(
//                   value: _attendance[student.id],
//                   onChanged: (bool? value) {
//                     setState(() {
//                       _attendance[student.id] = value!;
//                     });
//                   },
//                   title: Text(student.fullname),
//                 );
//               },
//             ),
//           ),

//           // Submit button
//           ElevatedButton(
//             onPressed: _submitAttendance,
//             child: const Text('Submit Attendance'),
//           ),
//         ],
//       ),
//     );
//   }
// }
