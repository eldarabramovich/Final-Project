/*

import 'package:flutter/material.dart';
import 'package:frontend/models/teachermodel.dart';
import 'package:frontend/Teacher/Deshboards/HomeroomTeacherDashboard.dart';
import 'package:frontend/Teacher/Deshboards/SubjectTeacherDashboard.dart';

class ClassSelectionPage extends StatelessWidget {
  final Teacher teacherData;
  final String userId;
  final bool isHomeroomTeacher;

  ClassSelectionPage({
    required this.teacherData,
    required this.userId,
    required this.isHomeroomTeacher,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Class'),
      ),
      body: ListView.builder(
        itemCount: isHomeroomTeacher
            ? teacherData.classesHomeroom.length
            : teacherData.classesSubject.length,
        itemBuilder: (context, index) {
          var classItem = isHomeroomTeacher
              ? teacherData.classesHomeroom[index]
              : teacherData.classesSubject[index];
          return ListTile(
            title: Text(classItem.classname),
            subtitle: Text(isHomeroomTeacher ? '' : classItem.subject),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => isHomeroomTeacher
                      ? HomeroomTeacherDashboard(
                          userId: userId,
                          teacherData: teacherData,
                          selectedClass: classItem.classname,
                        )
                      : SubjectTeacherDashboard(
                          userId: userId,
                          teacherData: teacherData,
                          selectedClass: classItem.classname,
                          selectedSubject: classItem.subject,
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


*/
import 'package:flutter/material.dart';
import 'package:frontend/models/teachermodel.dart';
import 'package:frontend/Teacher/Deshboards/HomeroomTeacherDashboard.dart';
import 'package:frontend/Teacher/Deshboards/SubjectTeacherDashboard.dart';

class ClassSelectionPage extends StatelessWidget {
  final Teacher teacherData;
  final String userId;
  final bool isHomeroomTeacher;

  ClassSelectionPage({
    required this.teacherData,
    required this.userId,
    required this.isHomeroomTeacher,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('בחר כיתה', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'אנא בחר את הכיתה המתאימה:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: isHomeroomTeacher
                  ? teacherData.classesHomeroom.length
                  : teacherData.classesSubject.length,
              itemBuilder: (context, index) {
                var classItem = isHomeroomTeacher
                    ? teacherData.classesHomeroom[index]
                    : teacherData.classesSubject[index];
                return Card(
                  color: Colors.blue.shade200,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          ' ${classItem.classname} : כיתה',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        if (!isHomeroomTeacher)
                          Text(
                            ' ${classItem.subject} : מקצוע',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => isHomeroomTeacher
                              ? HomeroomTeacherDashboard(
                                  userId: userId,
                                  teacherData: teacherData,
                                  selectedClass: classItem.classname,
                                )
                              : SubjectTeacherDashboard(
                                  userId: userId,
                                  teacherData: teacherData,
                                  selectedClass: classItem.classname,
                                  selectedSubject: classItem.subject,
                                ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
