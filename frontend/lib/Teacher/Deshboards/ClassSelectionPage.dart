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
        title: Text('בחר כיתה'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'נא לבחור הכיתה המתאימה כדי לבצע הפעולות המובקשות',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
                  color: Colors.grey[200], // Set card color to light gray
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      classItem.classname,
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      isHomeroomTeacher ? '' : classItem.subject,
                      textAlign: TextAlign.center,
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
