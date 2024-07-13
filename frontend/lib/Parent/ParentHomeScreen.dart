/*

import 'package:flutter/material.dart';

class ParentHomeScreen extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> childData;

  const ParentHomeScreen({Key? key, required this.userId, required this.childData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Home - ${childData['fullname']}'),
      ),
      body: Center(
        child: Text('Welcome ${childData['fullname']}\'s Parent!'),
      ),
    );
  }
}


*/

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Parent/ParentChildGradesPage.dart'; // Replace with actual import paths
import 'package:frontend/Parent/ParentSendMessagePage.dart'; // Replace with actual import paths
import 'package:frontend/Parent/ParentEventsPage.dart'; // Replace with actual import paths
import 'package:frontend/Parent/ParentCalendarPage.dart'; // Replace with actual import paths
import 'package:google_fonts/google_fonts.dart';

class ParentHomeScreen extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> childData;

  const ParentHomeScreen({
    Key? key,
    required this.userId,
    required this.childData,
  }) : super(key: key);

  void userLogOut(BuildContext context) {
    // Implement logout logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${childData['fullname']}'),
        actions: [
          IconButton(
            onPressed: () => userLogOut(context),
            icon: Icon(Icons.logout),
          )
        ],
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          // Part 1: Basic information about the parent
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
                          " Welcome Parent ",
                          style: GoogleFonts.notoSerifHebrew(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "שלום",
                          style: GoogleFonts.notoSerifHebrew(
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),

          // Part 2: Navigation cards
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
                        ParentHomeCard(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParentChildGradesPage(
                                  userId: userId,
                                  childData: childData,
                                ),
                              ),
                            );
                          },
                          icon: 'asset/icons/result.svg',
                          title: "View Grades",
                        ),
                        ParentHomeCard(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParentSendMessagePage(
                                  userId: userId,
                                  childData: childData,
                                ),
                              ),
                            );
                          },
                          icon: 'asset/icons/ask.svg',
                          title: "שליחת הודעה",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ParentHomeCard(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParentEventsPage(
                                  userId: userId,
                                  childData: childData,
                                ),
                              ),
                            );
                          },
                          icon: 'asset/icons/timetable.svg',
                          title: "אירועים",
                        ),
                        ParentHomeCard(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParentCalendarPage(
                                  userId: userId,
                                  childData: childData,
                                ),
                              ),
                            );
                          },
                          icon: 'asset/icons/timetable.svg',
                          title: "לוח שנה",
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

class ParentHomeCard extends StatelessWidget {
  const ParentHomeCard({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.title,
    this.color = Colors.black,
    this.elevation = 4.0,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String icon;
  final String title;
  final Color color;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.only(top: 40.0),
        width: MediaQuery.of(context).size.width / 2.5,
        height: MediaQuery.of(context).size.height / 6,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 247, 247, 247),
          borderRadius: BorderRadius.circular(20.0),
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
            ),
            Text(
              title,
              style: GoogleFonts.notoSerifHebrew(
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
