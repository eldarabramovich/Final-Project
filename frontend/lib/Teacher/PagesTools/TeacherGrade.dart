import 'package:flutter/material.dart';
import 'package:frontend/config.dart';

class TeacherGrade extends StatelessWidget {
  const TeacherGrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ציונים"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text("זה מסך הציונים"),
      ),
    );
  }
}
