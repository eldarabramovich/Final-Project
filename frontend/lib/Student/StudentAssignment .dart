import 'package:flutter/material.dart';
import 'package:frontend/models/assigmentmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentAssignment extends StatefulWidget {
  final String userId;

  const StudentAssignment({Key? key, required this.userId}) : super(key: key);

  @override
  _StudentAssignmentState createState() => _StudentAssignmentState();
}

class _StudentAssignmentState extends State<StudentAssignment> {
  late Future<List<AssignmentData>> futureAssignments;

  @override
  void initState() {
    super.initState();
    futureAssignments = fetchAssignments();
  }

  Future<List<AssignmentData>> fetchAssignments() async {
    var url =
        Uri.parse('http://192.168.31.51:3000/student/getassi/${widget.userId}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var responseBody = response.body;
      print('API Response: $responseBody');

      List<dynamic> assignmentJson = json.decode(responseBody) ?? [];
      return assignmentJson
          .map((json) => AssignmentData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load assignments');
    }
  }

  Future<void> downloadFile(String fileId) async {
    var url =
        Uri.parse('http://192.168.31.51:3000/students/downloadFile/$fileId');
    print('Download URL: $url');

    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      Fluttertoast.showToast(msg: "Could not launch $url");
      print('Could not launch URL: $url');
    }
  }

  Future<void> submitAssignment(String assignmentId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.31.51:3000/student/uploadassi'));
      request.fields['studentId'] = widget.userId;
      request.fields['assignmentId'] = assignmentId;
      request.files.add(http.MultipartFile(
        'file',
        file.readStream!,
        file.size,
        filename: file.name,
      ));

      var response = await request.send();

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "File uploaded successfully");
      } else {
        Fluttertoast.showToast(msg: "Failed to upload file");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("מטלות"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: FutureBuilder<List<AssignmentData>>(
        future: futureAssignments,
        builder: (BuildContext context,
            AsyncSnapshot<List<AssignmentData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<AssignmentData> assignments = snapshot.data ?? [];
            return ListView.builder(
              padding: EdgeInsets.all(20.0),
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                return AssignmentCard(
                  assignment: assignments[index],
                  onDownload: () => downloadFile(assignments[index].id),
                  onSubmit: () => submitAssignment(assignments[index].id),
                );
              },
            );
          } else {
            return Center(child: Text('No assignments found'));
          }
        },
      ),
    );
  }
}

class AssignmentButton extends StatelessWidget {
  const AssignmentButton(
      {super.key, required this.title, required this.onPress});

  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: double.infinity,
        height: 40.0,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Color(0xFF6789CA), Color(0xFF345FB4)],
              begin: const FractionalOffset(0.0, 0.0),
              end: const FractionalOffset(0.5, 0.0),
              stops: const [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
            borderRadius: BorderRadius.circular(20.0)),
        child: Center(
            child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: Color.fromARGB(255, 255, 255, 255)),
        )),
      ),
    );
  }
}

class AssignmentDetailRow extends StatelessWidget {
  const AssignmentDetailRow(
      {super.key, required this.title, required this.statusValue});

  final String title;
  final String statusValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          statusValue,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: const Color.fromARGB(255, 43, 42, 42),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Color(0xFFA5A5A5),
          ),
        ),
      ],
    );
  }
}

class AssignmentCard extends StatelessWidget {
  final AssignmentData assignment;
  final VoidCallback onDownload;
  final VoidCallback onSubmit;

  const AssignmentCard({
    Key? key,
    required this.assignment,
    required this.onDownload,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.subjectname,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF345FB4),
              ),
            ),
            SizedBox(height: 10),
            Text(
              assignment.description,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Due: ${assignment.lastDate}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.0,
              ),
            ),
            SizedBox(height: 10),
            AssignmentButton(
              title: 'Download',
              onPress: onDownload,
            ),
            AssignmentButton(
              title: 'Submit',
              onPress: onSubmit,
            ),
          ],
        ),
      ),
    );
  }
}
