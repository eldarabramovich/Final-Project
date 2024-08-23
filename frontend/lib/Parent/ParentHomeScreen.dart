import 'package:flutter/material.dart';
import 'package:frontend/models/parentmodel.dart'; // Assuming you have a parent model
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/Parent/ParentChildGrade.dart'; // Replace with actual import paths
import 'package:frontend/Parent/ParentSendMessagePage.dart'; // Replace with actual import paths
import 'package:frontend/Admin/EventsPage.dart'; // Replace with actual import paths
import 'package:frontend/Parent/ParentCalendarPage.dart'; // Replace with actual import paths
import 'package:frontend/Parent/ParentAttendance.dart'; // Import the ParentAttendance page
import 'package:google_fonts/google_fonts.dart';

class ParentDashboard extends StatefulWidget {
  final Parent parent;
  final Children selectedChild;

  const ParentDashboard({required this.parent, required this.selectedChild});

  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  @override
  void initState() {
    super.initState();
  }

  void userLogOut(BuildContext context) {
    // Implement logout logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => userLogOut(context),
            icon: const Icon(Icons.logout),
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
            padding: const EdgeInsets.all(20),
            color: Colors.blue.shade800,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          " Welcome ${widget.parent.fullname}",
                          style: GoogleFonts.notoSerifHebrew(
                            fontWeight: FontWeight.bold,
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
                decoration: const BoxDecoration(
                  color: Color(0xFFF4F6F7),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ParentHomeCard(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ParentChildGrade(
                                  parent: widget.parent,
                                  selectedChild: widget.selectedChild,
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
                                builder: (context) => ParentCalendarPage(
                                  userId: widget.parent.id,
                                  children: widget.selectedChild,
                                ),
                              ),
                            );
                          },
                          icon: 'asset/icons/timetable.svg',
                          title: "לוח שנה",
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
                                builder: (context) => ParentSendMessagePage(
                                  userId: widget.parent.id,
                                  selectedChild: widget.selectedChild,
                                ),
                              ),
                            );
                          },
                          icon: 'asset/icons/result.svg',
                          title: "הודעות",
                        ),
                        ParentHomeCard(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventsPage(),
                              ),
                            );
                          },
                          icon:
                              'asset/icons/attendance.svg', // Update with actual icon path
                          title: "אירועים",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ParentHomeCard(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudentAttendancePage(
                    selectedChild: widget.selectedChild,
                  ),
                ),
              );
            },
            icon: 'asset/icons/attendance.svg', // Update with actual icon path
            title: "נוחכות",
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
        margin: const EdgeInsets.only(top: 40.0),
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
              offset: const Offset(0, 2), // Adjust the offset as needed
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
