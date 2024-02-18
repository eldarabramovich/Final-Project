import 'package:flutter/material.dart';

class StudentMessages extends StatelessWidget {
  const StudentMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("הודעות"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Center(
        child: Text("זה מסך של הודעות"),
      ),
    );
  }
}
