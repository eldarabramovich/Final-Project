import 'package:flutter/material.dart';

import 'package:frontend/Teacher/TeacherClassDetailPage.dart';

class TeacherClassesPage extends StatelessWidget {
  final List<Map<String, String>> classes = [
    {'classname': 'כיתה א', 'subject': 'מתמטיקה'},
    {'classname': 'כיתה ב', 'subject': 'מדע'},
    {'classname': 'כיתה ג', 'subject': 'היסטוריה'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('הכיתות שלי', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  classes[index]['classname']!,
                  textAlign: TextAlign.right,
                ),
              ),
              subtitle: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  classes[index]['subject']!,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TeacherClassDetailPage(
                      classname: classes[index]['classname']!,
                      subject: classes[index]['subject']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
