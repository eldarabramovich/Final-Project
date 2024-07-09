import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
class StudentPresence extends StatelessWidget {
  const StudentPresence({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("נוכחות"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text("זה מסך של נוכחות"),
      ),
    );
  }
}
