import 'package:flutter/material.dart';

class TeacherEventPage extends StatelessWidget {
  const TeacherEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("האירועים"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text("זה מסך האירועים"),
      ),
    );
  }
}
