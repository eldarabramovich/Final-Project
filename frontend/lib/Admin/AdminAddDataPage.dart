// AdminAddDataPage.dart

import 'package:flutter/material.dart';
import 'package:frontend/Admin/AdminAddClassroom.dart';
import 'package:frontend/Admin/AdminAddParent.dart';
import 'package:frontend/Admin/AdminAddStudent.dart';
import 'package:frontend/Admin/AdminAddTeacher.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminAddDataPage extends StatelessWidget {
  static String routeName = 'AdminAddDataPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('הוספת נתונים חדשים'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HomeCard(
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddStudentPage()),
                  );
                },
                icon: 'asset/icons/students.png',
                title: "תלמיד חדש",
              ),
              HomeCard(
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminAddClassroom()),
                  );
                },
                icon: 'asset/icons/classroom.png',
                title: "כיתה חדשה",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HomeCard(
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminAddTeacher()),
                  );
                },
                icon: 'asset/icons/teacher.png',
                title: "מורה חדש",
              ),
              HomeCard(
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminAddParent()),
                  );
                },
                icon: 'asset/icons/parents.png',
                title: "הורה חדש",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.onPress,
    required this.icon,
    required this.title,
    this.color = Colors.black,
    this.elevation = 4.0,
  });

  final VoidCallback onPress;
  final String icon;
  final String title;
  final Color color;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.only(top: 40.0),
        width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.height / 6,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 247, 247, 247),
          borderRadius: BorderRadius.circular(20.0 / 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 55.0,
              width: 55.0,
              // Don't set color here as it might cause the image to appear shaded.
            ),
            Text(
              title,
              style: GoogleFonts.notoSerifHebrew(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 20.0 / 3,
            ),
          ],
        ),
      ),
    );
  }
}
