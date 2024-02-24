import 'package:flutter/material.dart';

class StudentPresence extends StatelessWidget {
  const StudentPresence({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("נוכחות"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Center(
        child: Text("זה מסך של נוכחות"),
      ),
    );
  }
}
