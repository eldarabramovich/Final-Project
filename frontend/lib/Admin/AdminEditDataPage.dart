// AdminEditDataPage.dart
// AdminEditDataPage.dart

import 'package:flutter/material.dart';
import 'package:frontend/Admin/StudentEdit.dart';
import 'package:frontend/Admin/TeacherEdit.dart';
import 'package:frontend/Admin/ParentEdit.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminEditDataPage extends StatelessWidget {
  static String routeName = 'AdminEditDataPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('עריכת נתונים קיימים'),
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
                    MaterialPageRoute(builder: (context) => EditStudentPage()),
                  );
                },
                icon: 'asset/icons/students.png',
                title: "עריכה תלמיד ",
              ),
              HomeCard(
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditTeacherPage()),
                  );
                },
                icon: 'asset/icons/teacher.png',
                title: "עריכה מורה ",
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
                    MaterialPageRoute(builder: (context) => EditTeacherPage()),
                  );
                },
                icon: 'asset/icons/parents.png',
                title: "עריכה הורה ",
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
