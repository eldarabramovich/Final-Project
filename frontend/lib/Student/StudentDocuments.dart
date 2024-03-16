import 'package:flutter/material.dart';

class StudentDocuments extends StatelessWidget {
  const StudentDocuments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("מסמכים"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text("זה מסך של מסמכים"),
      ),
    );
  }
}
