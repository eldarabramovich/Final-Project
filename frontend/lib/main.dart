import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class AssignmentData {
  final String id;
  final String classname;
  final String subjectname;
  final String description;
  final String lastDate;

  AssignmentData({
    required this.id,
    required this.classname,
    required this.subjectname,
    required this.description,
    required this.lastDate,
  });

  factory AssignmentData.fromJson(Map<String, dynamic> json) {
    return AssignmentData(
      id: json['id'],
      classname: json['classname'],
      subjectname: json['subjectname'],
      description: json['description'],
      lastDate: json['lastDate'],
    );
  }
}
