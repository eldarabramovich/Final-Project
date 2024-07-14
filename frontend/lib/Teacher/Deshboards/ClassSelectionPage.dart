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
            ? teacherData.classHomeroom.length
            : teacherData.classesSubject.length,
        itemBuilder: (context, index) {
          if (isHomeroomTeacher) {
            var classItem = teacherData.classHomeroom[index];
            return ListTile(
              title: Text(classItem),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeroomTeacherDashboard(
                      userId: userId,
                      teacherData: teacherData,
                      selectedClass: classItem,
                    ),
                  ),
                );
              },
            );
          } else {
            var classItem = teacherData.classesSubject[index];
            return ListTile(
              title: Text(classItem.classname),
              subtitle: Text(classItem.subject),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectTeacherDashboard(
                      userId: userId,
                      teacherData: teacherData,
                      selectedClass: classItem.classname,
                      selectedSubject: classItem.subject,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
