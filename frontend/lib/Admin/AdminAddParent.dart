import 'package:flutter/material.dart';

class AdminAddParent extends StatelessWidget {
  const AdminAddParent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("הורה חדש"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Center(
        child: Text("זה מסך של הוספת הורה חדש"),
      ),
    );
  }
}
