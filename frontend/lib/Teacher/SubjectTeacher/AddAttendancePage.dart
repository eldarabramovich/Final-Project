import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
import 'package:frontend/models/studenmodel.dart';

class AddAttendancePage extends StatefulWidget {
  final String selectedClass;
  final String subject;

  const AddAttendancePage(
      {Key? key, required this.selectedClass, required this.subject})
      : super(key: key);

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
    var url = Uri.parse(
        'http://${Config.baseUrl}/teacher/getstudents/${widget.selectedClass}');
    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> studentsJson = json.decode(response.body);
        setState(() {
          _students =
              studentsJson.map((json) => Student.fromFirestore(json)).toList();
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
              'status':
                  _attendance[student.id] ?? 'נעדר', // Default to 'Absent'
            };
          }).toList(),
          'presdate': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('הנוכחות התווספה בהצלחה')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בהוספת נוכחות: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('חריגה: $e')),
      );
    }
  }

  Icon _getStatusIcon(String status) {
    switch (status) {
      case 'נוכח':
        return Icon(Icons.check_circle, color: Colors.green.shade400, size: 20);
      case 'מאחר':
        return Icon(Icons.warning, color: Colors.orange.shade400, size: 20);
      case 'נעדר':
        return Icon(Icons.cancel, color: Colors.red.shade400, size: 20);
      default:
        return Icon(Icons.help, color: Colors.grey.shade400, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('הוספת נוכחות'),
        backgroundColor:
            Colors.blue.shade800, // Adjust to your app's color scheme
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'בחר נוכחות לתלמידים',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Column(
                    children: _students.map((student) {
                      return Card(
                        elevation: 4.0,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.fullname,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _buildStatusRadio(student.id, 'נוכח', 'נוכח',
                                      Colors.green.shade400),
                                  _buildStatusRadio(student.id, 'מאחר', 'מאחר',
                                      Colors.orange.shade400),
                                  _buildStatusRadio(student.id, 'נעדר', 'נעדר',
                                      Colors.red.shade400),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _submitAttendance,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          Colors.blue.shade800, // Button text color
                      minimumSize: Size(double.infinity, 50),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text(
                      'שלח נוכחות',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusRadio(
      String studentId, String value, String label, Color color) {
    return Flexible(
      child: Row(
        children: [
          Icon(_getStatusIcon(value).icon, color: color, size: 20),
          SizedBox(width: 4.0),
          Expanded(
            child: RadioListTile<String>(
              title: Text(label, style: TextStyle(fontSize: 12)),
              value: value,
              groupValue: _attendance[studentId],
              onChanged: (value) {
                setState(() {
                  _attendance[studentId] = value!;
                });
              },
              activeColor: color,
              contentPadding: EdgeInsets.zero, // Remove extra padding
            ),
          ),
        ],
      ),
    );
  }
}
