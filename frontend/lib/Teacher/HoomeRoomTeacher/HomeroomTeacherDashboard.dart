// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/models/teachermodel.dart';
import 'package:frontend/Teacher/PagesTools/TeacherCalendar.dart';
import 'package:frontend/Teacher/PagesTools/TeacherMessages.dart';
import 'package:frontend/Teacher/HoomeRoomTeacher/TeacherStudentsGrades.dart';
import 'package:frontend/Teacher/HoomeRoomTeacher/AttendanceStudentsManage.dart';
import 'package:frontend/Admin/EventsPage.dart';

class HomeroomTeacherDashboard extends StatelessWidget {
  final String userId;
  final Teacher teacherData;
  final String selectedClass;

  HomeroomTeacherDashboard({
    required this.userId,
    required this.teacherData,
    required this.selectedClass,
  });

  // ignore: non_constant_identifier_names
  void UserLogOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: UserLogOut,
            icon: Icon(Icons.logout),
          )
        ],
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          // The part 1, basic information about the teacher:
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 10.0,
            padding: EdgeInsets.all(20),
            color: Colors.blue.shade800,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          " Welcome Teacher ",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                        ),
                        Text(
                          "שלום",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white,
                                  ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),

          Expanded(
            child: Container(
              color: Colors.blue.shade800,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xFFF4F6F7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeacherSendMessage(
                                        userId: userId,
                                        selectedClass: selectedClass,
                                      )),
                            );
                          },
                          icon: 'asset/icons/chat.svg',
                          title: "הודעות",
                        ),
                        HomeCard(
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeacherStudentsGrades(
                                        selectedClass: selectedClass,
                                      )),
                            );
                          },
                          icon: 'asset/icons/timetable.svg',
                          title: "ציוני תלמידים",
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
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AttendanceStudentsManage(
                                          userId: userId,
                                          selectedClass: selectedClass)),
                            );
                          },
                          icon: 'asset/icons/chat.svg',
                          title: "נוחכות",
                        ),
                        HomeCard(
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeacherCalendar(
                                        userId: userId,
                                      )),
                            );
                          },
                          icon: 'asset/icons/calendar.svg',
                          title: "לוח שנה",
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
                              MaterialPageRoute(
                                  builder: (context) => EventsPage()),
                            );
                          },
                          icon: 'asset/icons/events.svg',
                          title: "אירועים",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
        margin: EdgeInsets.only(top: 40.0),
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
              offset: Offset(0, 2), // Adjust the offset as needed
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: 55.0,
              width: 55.0,
              color: color,
              //color: Color.fromARGB(255, 35, 155, 214),
            ),
            Text(
              title,
              style: GoogleFonts.notoSerifHebrew(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20.0 / 3,
            ),
          ],
        ),
      ),
    );
  }
}
