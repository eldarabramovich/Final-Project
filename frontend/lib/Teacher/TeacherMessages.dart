import 'package:flutter/material.dart';

class TeacherMessages extends StatelessWidget {
  const TeacherMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ציונים"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Center(
        child: Text("מסך של בחירת כיתה ואחר-כך הזנת הציוניים"),
      ),
    );
  }
}
