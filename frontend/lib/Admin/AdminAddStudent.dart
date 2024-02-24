import 'package:flutter/material.dart';

class AdminAddStudent extends StatelessWidget {
  const AdminAddStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("תלמיד חדש"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Center(
        child: Text("זה מסך של הוספת תלמיד חדש"),
      ),
    );
  }
}
