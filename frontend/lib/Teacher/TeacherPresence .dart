// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:frontend/Teacher/StudentListPage.dart';
//import 'student_list_page.dart'; // Import the student list page file
import 'package:frontend/config.dart';

class TeacherPresence extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Mock data for demonstration
    List<Map<String, dynamic>> classesSubjects = [
      {
        'className': 'ה2',
        'subjects': ['אלגברה']
      },
      {
        'className': 'ו1',
        'subjects': ['פיזיקה']
      },
      {
        'className': 'ה2',
        'subjects': ['עבברית']
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'נוחכות',
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView.builder(
        itemCount: classesSubjects.length,
        itemBuilder: (context, index) {
          var className = classesSubjects[index]['className'];
          var subjects = classesSubjects[index]['subjects'];

          return GestureDetector(
            onTap: () {
              // Navigate to student list page when the card is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentListPage(className: className),
                ),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'כיתה: $className',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'נושא:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: subjects.map<Widget>((subject) {
                              return Text(
                                ' $subject',
                                textAlign: TextAlign.right,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
