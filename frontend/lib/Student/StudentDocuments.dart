import 'package:flutter/material.dart';

class StudentDocuments extends StatelessWidget {
  const StudentDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("מסמכים"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Center(
        child: Text("זה מסך של מסמכים"),
      ),
    );
  }
}
