import 'package:flutter/material.dart';

class StudentGrade extends StatelessWidget {
  const StudentGrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ציונים"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Center(
        child: Text("זה מסך של ציונים"),
      ),
    );
  }
}
