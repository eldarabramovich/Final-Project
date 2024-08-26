// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Parent/ParentHomeScreen.dart';
import 'package:frontend/Parent/ChildSelectionPage.dart';
import 'package:frontend/Admin/AdminHomeScreen.dart';
import 'package:frontend/Student/StudentHomeScreen.dart';
import 'package:frontend/Teacher/SubjectTeacher/SubjectTeacherDashboard.dart';
import 'package:frontend/Teacher/PagesTools/ClassSelectionPage.dart';
import 'package:frontend/Teacher/HoomeRoomTeacher/HomeroomTeacherDashboard.dart';
import 'package:frontend/models/teachermodel.dart';
import 'package:frontend/models/parentmodel.dart';
import 'config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void logUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    var requestBody = json.encode({
      'username': emailController.text,
      'password': passwordController.text,
    });

    try {
      var response = await http.post(
        Uri.parse('http://${Config.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );
      Navigator.pop(context);

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var role = responseData['role'].trim(); // Trim whitespace
        var userId = responseData['userId'];
        if (role == 'admin') {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminHomeScreen()));
        } else if (role == 'students') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(userId: userId)));
        } else if (role == 'teachers') {
          var teacherData = await fetchTeacherData(userId);
          print(
              "Fetched Teacher Data: $teacherData"); // Add this line for debugging
          var teacher = Teacher.fromFirestore(teacherData);
          print("Parsed Teacher: $teacher"); // Add this line for debugging

          if (teacher.classesSubject.isNotEmpty &&
              (teacher.classHomeroom.isNotEmpty &&
                  teacher.classHomeroom.first.isNotEmpty)) {
            showErrorSnackBar(context, 'Teacher cant be homeroom and subjects');
          } else if (teacher.classHomeroom.isNotEmpty &&
              teacher.classHomeroom.first.isNotEmpty) {
            if (teacher.classHomeroom.length == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeroomTeacherDashboard(
                    userId: userId,
                    teacherData: teacher,
                    selectedClass: teacher.classHomeroom.first,
                  ),
                ),
              );
            } else if (teacher.classHomeroom.length > 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassSelectionPage(
                    teacherData: teacher,
                    userId: userId,
                    isHomeroomTeacher: true,
                  ),
                ),
              );
            } else {
              showErrorSnackBar(
                  context, 'Teacher has no homeroom classes assigned.');
            }
          } else if (teacher.classesSubject.isNotEmpty) {
            if (teacher.classesSubject.length == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubjectTeacherDashboard(
                    userId: userId,
                    teacherData: teacher,
                    selectedClass: teacher.classesSubject.first.classname,
                    selectedSubject: teacher.classesSubject.first.subject,
                  ),
                ),
              );
            } else if (teacher.classesSubject.length > 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassSelectionPage(
                    teacherData: teacher,
                    userId: userId,
                    isHomeroomTeacher: false,
                  ),
                ),
              );
            } else {
              showErrorSnackBar(context, 'Teacher has no classes assigned.');
            }
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ClassSelectionPage(
                  teacherData: teacher,
                  userId: userId,
                  isHomeroomTeacher: teacher.classHomeroom.isNotEmpty &&
                      teacher.classHomeroom.first.isNotEmpty,
                ),
              ),
            );
          }
        } else if (role == 'parents') {
          var parentData = await fetchParentData(userId);
          Parent parent = Parent.fromFirestore(parentData);
          if (parent.children.length == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ParentDashboard(
                  parent: parent,
                  selectedChild: parent.children[0],
                ),
              ),
            );
          } else if (parent.children.length > 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChildSelectionPage(
                  parent: parent,
                ),
              ),
            );
          } else {
            showErrorSnackBar(context, 'No children found for this parent.');
          }
        } else {
          showErrorSnackBar(context, 'Invalid role.');
        }
      } else {
        showErrorSnackBar(
            context, 'Login failed. Please check your credentials.');
      }
    } catch (error) {
      Navigator.pop(context);
      print('Error: $error');
      showErrorSnackBar(context, 'Network error. Please try again later.');
    }
  }

  Future<Map<String, dynamic>> fetchParentData(String userId) async {
    final response = await http.get(
        Uri.parse('http://${Config.baseUrl}/parent/getParentData/$userId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load parent data');
    }
  }

  Future<Map<String, dynamic>> fetchTeacherData(String userId) async {
    var url = Uri.parse('http://${Config.baseUrl}/teacher/teacher/$userId');

    try {
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to fetch teacher data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching teacher data: $e');
      throw Exception('Failed to fetch teacher data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Center(
                    child: Image(
                  image: AssetImage('asset/imgs/logo.jpg'),
                  width: 120,
                  height: 120,
                )),
                const SizedBox(height: 50),
                Text(
                  "TeachTouch",
                  style: GoogleFonts.oswald(
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 53, 162, 212),
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Learn. Connect. Thrive.",
                  style: GoogleFonts.lora(
                    fontWeight: FontWeight.normal,
                    color: const Color.fromARGB(255, 53, 162, 212),
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: emailController,
                    textAlign: TextAlign.right, // Align hint text to the right
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person), // Profile icon
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "שם משתמש",
                      fillColor: Colors.grey.shade100,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    textAlign: TextAlign.right, // Align hint text to the right
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock), // Lock icon
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ), // Toggle visibility icon
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "סיסמה",
                      fillColor: Colors.grey.shade100,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: logUserIn,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 53, 162, 212),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "כניסה",
                          style: GoogleFonts.assistant(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  "!מצטרפים להצלחה חינוכית בקליק אחד",
                  style: GoogleFonts.assistant(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
