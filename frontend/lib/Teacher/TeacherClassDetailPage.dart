import 'package:flutter/material.dart';

class TeacherClassDetailPage extends StatelessWidget {
  final String classname;
  final String subject;

  TeacherClassDetailPage({required this.classname, required this.subject});

  final List<Map<String, dynamic>> students = [
    {'name': 'יוסי כהן', 'grade': ''},
    {'name': 'מיכל לוי', 'grade': ''},
    {'name': 'אבי נעים', 'grade': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$classname - $subject',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Add your save logic here
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  students[index]['name'],
                  textAlign: TextAlign.right,
                ),
              ),
              trailing: SizedBox(
                width: 100,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'ציון',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  onChanged: (value) {
                    students[index]['grade'] = value;
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
