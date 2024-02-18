import 'package:flutter/material.dart';

class TeacherCalendar extends StatelessWidget {
  const TeacherCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("לוח שנה"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Center(
        child: Text("זה מסך של לוח שנה"),
      ),
    );
  }
}
