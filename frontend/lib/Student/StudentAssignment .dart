// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/models/assigmentmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../models/studenmodel.dart';
import 'package:frontend/config.dart';

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
        Uri.parse('http://10.0.0.22:3000/student/getassi/${widget.userId}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> assignmentJson = json.decode(response.body);
      return assignmentJson
          .map((json) => AssignmentData.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load assignments');
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
                return AssignmentCard(assignment: assignments[index]);
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

  const AssignmentCard({Key? key, required this.assignment}) : super(key: key);

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
            // You can add more details or actions for the assignment card here.
          ],
        ),
      ),
    );
  }
}
