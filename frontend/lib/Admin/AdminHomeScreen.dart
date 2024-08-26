// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Admin/AdminAddDataPage.dart';
import 'package:frontend/Admin/AdminAddEventPage.dart';
import 'package:frontend/Admin/TeacherEdit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/Admin/AdminAddClassroom.dart';
import 'package:frontend/Admin/AdminAddParent.dart';
import 'package:frontend/Admin/AdminAddStudent.dart';
import 'package:frontend/Admin/AdminAddTeacher.dart';
import 'package:frontend/Admin/StudentEdit.dart';
import 'package:frontend/Admin/EventsPage.dart';
import 'package:intl/intl.dart';
import 'package:frontend/Admin/AdminEditDataPage.dart';

class AdminHomeScreen extends StatelessWidget {
  static String routeName = 'AdminHomeScreen';
  const AdminHomeScreen({super.key});

  //final user = FirebaseAuth.instance.currentUser!;

  void UserLogOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

    String formattedTime = TimeOfDay.now().format(context);
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
          //divide the screen into two parts
          //The part 1, basic information about the student:

          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.0,
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade800,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'asset/icons/usericon.png',
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Welcome Admin",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '$formattedDate | $formattedTime',
                  style: GoogleFonts.notoSerifHebrew(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
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
                                  builder: (context) => AdminAddEventPage()),
                            );
                          },
                          icon: 'asset/icons/newpost.png',
                          title: "אירוע חדש",
                        ),
                        HomeCard(
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventsPage()),
                            );
                          },
                          icon: 'asset/icons/event.png',
                          title: "רישמת האירועים",
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
                                  builder: (context) => AdminAddDataPage()),
                            );
                          },
                          icon: 'asset/icons/newdatabase.png',
                          title: "הוספת נתונים",
                        ),
                        HomeCard(
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminEditDataPage()),
                            );
                          },
                          icon: 'asset/icons/editdata.png',
                          title: "עריכת נתונים",
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

      //body: Center(child: Text("Welcome back " + user.email!)),
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
