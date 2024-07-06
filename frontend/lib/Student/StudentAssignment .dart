// ignore: file_names

import 'dart:io';
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
  Student? student;
  @override
  void initState() {
    super.initState();
    fetchStudentData();
    futureAssignments = fetchAssignments();
  }

  Future<void> fetchStudentData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://192.168.31.51:3000/student/getstudent/${widget.userId}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          student = Student.fromFirestore(data);
        });
      } else {
        print('Failed to load student data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching student data: $e');
    }
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
    print('enter download file function for file ID: $fileId');
    Dio dio = Dio();
    try {
      // Request storage permission
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        print('Storage permission denied');
        Fluttertoast.showToast(
            msg: "Storage permission is required to download files");
        return;
      }

      // Get the external storage directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        // Fallback to app's directory if /storage/emulated/0/Download is not available
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        print('Unable to access storage directory');
        Fluttertoast.showToast(msg: "Unable to access storage directory");
        return;
      }
      print('Storage Directory: ${directory.path}');

      print(
          'Getting file from: http://192.168.31.51:3000/student/downloadFile/$fileId');
      final response = await dio.get(
        'http://192.168.31.51:3000/student/downloadFile/$fileId',
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response headers: ${response.headers}');

      if (response.statusCode == 200) {
        String fileName = 'download_${DateTime.now().millisecondsSinceEpoch}';
        String? contentDisposition =
            response.headers.value('content-disposition');
        String? contentType = response.headers.value('content-type');
        print('Content-Disposition header: $contentDisposition');
        print('Content-Type header: $contentType');

        if (contentDisposition != null) {
          RegExp regExp = RegExp(r"filename\*=UTF-8''(.+)");
          var match = regExp.firstMatch(contentDisposition);
          if (match != null && match.groupCount >= 1) {
            fileName = Uri.decodeComponent(match.group(1) ?? '');
          }
        }

        final filePath = path.join(directory.path, fileName);
        print('Saving file to: $filePath');

        File file = File(filePath);
        await file.writeAsBytes(response.data);

        print('File downloaded successfully');
        print('File size: ${await file.length()} bytes');
        print('File exists: ${await file.exists()}');

        Fluttertoast.showToast(
            msg: "File downloaded successfully to $filePath");
      } else {
        print('Error downloading file: ${response.statusCode}');
        Fluttertoast.showToast(
            msg: "Error downloading file: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print('Error during download: $e');
      print('Stack trace: $stackTrace');
      Fluttertoast.showToast(msg: "Error downloading file: $e");
    }
  }

  Future<void> submitAssignment(String assignmentId) async {
    if (student == null) {
      Fluttertoast.showToast(msg: "Student data not loaded");
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      PlatformFile file = result.files.first;
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.31.51:3000/student/addSubmission'));

      // Add file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path!,
        filename: file.name,
      ));

      // Add other fields
      request.fields['assignmentID'] = assignmentId;
      request.fields['fullName'] = student!.fullname;

      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "Assignment submitted successfully");
        } else {
          print('Server error: ${response.body}');
          Fluttertoast.showToast(
              msg: "Failed to submit assignment: ${response.statusCode}");
        }
      } catch (e) {
        print('Error submitting assignment: $e');
        Fluttertoast.showToast(msg: "Error submitting assignment: $e");
      }
    } else {
      Fluttertoast.showToast(msg: "No file selected");
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
            gradient: const LinearGradient(
              colors: [Color(0xFF6789CA), Color(0xFF345FB4)],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(0.5, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
            borderRadius: BorderRadius.circular(20.0)),
        child: Center(
            child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 16.0,
              color: const Color.fromARGB(255, 255, 255, 255)),
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
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 43, 42, 42),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
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
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              assignment.subjectname,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF345FB4),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              assignment.description,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Due: ${assignment.lastDate}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 10),
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
