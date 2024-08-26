// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'StudentAssignment.dart';
import 'StudentCalendar.dart';
import 'StudentDocuments.dart';
import 'StudentGrade.dart';
import 'StudentMessages.dart';
import 'StudentPresence.dart';
import '../models/studenmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Student? student;
  late Future<Student> _studentFuture;

  @override
  void initState() {
    super.initState();
    _studentFuture = fetchStudentData(widget.userId);
  }

  Future<Student> fetchStudentData(String userId) async {
    var url = Uri.parse('http://${Config.baseUrl}/student/getstudent/$userId');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return Student.fromFirestore(data);
      } else {
        throw Exception('Failed to fetch student data');
      }
    } catch (e) {
      throw Exception('Failed to fetch student data: $e');
    }
  }

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
      body: FutureBuilder<Student>(
        future: _studentFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading student data'));
          } else if (snapshot.hasData) {
            var student = snapshot.data!;
            return Column(
              children: [
                // Part 1: Basic information about the student

                /*
                
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
                                "  Welcome Student ",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                              Text(
                                student.fullname,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
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
                
                */

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
                              student.fullname,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
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

                // Part 2: Other sections
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
                                      builder: (context) => StudentAssignment(
                                          userId: widget.userId),
                                    ),
                                  );
                                },
                                icon: 'asset/icons/homework.png',
                                title: "מטלות",
                              ),
                              HomeCard(
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StudentGrade(
                                            studentName: student.fullname)),
                                  );
                                },
                                icon: 'asset/icons/grade.png',
                                title: "ציונים",
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              HomeCard(
                                onPress: () {
                                  if (student.subClassName != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StudentClassMessagesScreen(
                                          userId: widget.userId,
                                          selectedClass: student.subClassName!,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Sub Class Name is not available')),
                                    );
                                  }
                                },
                                icon: 'asset/icons/messages.png',
                                title: "הודעות",
                              ),
                              HomeCard(
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StudentCalendar()),
                                  );
                                },
                                icon: 'asset/icons/calendar.png',
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
                                        builder: (context) =>
                                            StudentPresence()),
                                  );
                                },
                                icon: 'asset/icons/checklist.png',
                                title: "נוכחות",
                              ),
                              HomeCard(
                                onPress: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            StudentDocuments()),
                                  );
                                },
                                icon: 'asset/icons/file.png',
                                title: "מסמכים",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No data found'));
          }
        },
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
    this.elevation = 4.0,
  });
  final VoidCallback? onPress;
  final String icon; // Path to the PNG icon
  final String title;
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
            Image.asset(
              icon, // Path to the PNG icon
              height: 55.0,
              width: 55.0,
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
