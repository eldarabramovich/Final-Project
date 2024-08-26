import 'package:flutter/material.dart';
import 'package:frontend/models/teachermodel.dart';
import 'package:frontend/Teacher/HoomeRoomTeacher/HomeroomTeacherDashboard.dart';
import 'package:frontend/Teacher/SubjectTeacher/SubjectTeacherDashboard.dart';

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of cards in a row
            crossAxisSpacing: 16.0, // Space between columns
            mainAxisSpacing: 16.0, // Space between rows
            childAspectRatio: 3 / 2, // Aspect ratio of the cards
          ),
          itemCount: isHomeroomTeacher
              ? teacherData.classHomeroom.length
              : teacherData.classesSubject.length,
          itemBuilder: (context, index) {
            if (isHomeroomTeacher) {
              var classItem = teacherData.classHomeroom[index];
              return GestureDetector(
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
                child: Card(
                  color: index % 2 == 0
                      ? Color(0xFFE57373)
                      : Color(0xFFFFF176), // Use colors from icons
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Text(
                      classItem,
                      style: TextStyle(
                        fontSize: 20.0, // Increased font size
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            } else {
              var classItem = teacherData.classesSubject[index];
              return GestureDetector(
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
                child: Card(
                  color: index % 2 == 0
                      ? Color(0xFF64B5F6)
                      : Color(0xFF4DB6AC), // Use colors from icons
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          classItem.classname,
                          style: TextStyle(
                            fontSize: 20.0, // Increased font size
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          classItem.subject,
                          style: TextStyle(
                            fontSize: 18.0, // Increased font size
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
