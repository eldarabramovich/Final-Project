// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/Teacher/TeacherAddNewAssi.dart';

class TeacherAssignment extends StatelessWidget {
  const TeacherAssignment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("מטלות"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TeacherAddNewAssi()),
              );
            },
          ),
        ],
        backgroundColor: Colors.blue.shade800,
      ),
      body: Center(
        child: Text("כאן מופיע המטלות של הממורה "),
      ),
    );
  }
}
