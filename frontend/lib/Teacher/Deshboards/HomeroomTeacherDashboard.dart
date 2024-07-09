import 'package:flutter/material.dart';
import 'package:frontend/models/teachermodel.dart';

class HomeroomTeacherDashboard extends StatelessWidget {
  final String userId;
  final Teacher teacherData;
  final String selectedClass;

  HomeroomTeacherDashboard({
    required this.userId,
    required this.teacherData,
    required this.selectedClass,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Homeroom Teacher Dashboard')),
      body: Center(child: Text('Class: $selectedClass')),
    );
  }
}
