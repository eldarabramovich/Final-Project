import 'package:flutter/material.dart';
import 'package:frontend/config.dart';

class StudentCalendar extends StatelessWidget {
  const StudentCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("לוח שנה"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text("זה מסך של לוח שנה"),
      ),
    );
  }
}
