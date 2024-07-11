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
