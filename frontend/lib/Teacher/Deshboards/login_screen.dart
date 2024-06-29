// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Admin/AdminHomeScreen.dart';
import 'package:frontend/Student/StudentHomeScreen.dart';
import 'package:frontend/Teacher/Deshboards/SubjectTeacherDashboard.dart';
import 'package:frontend/Teacher/Deshboards/ClassSelectionPage.dart';
import 'package:frontend/Teacher/Deshboards/HomeroomTeacherDashboard.dart';
import 'package:frontend/models/teachermodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
      Uri.parse('http://192.168.31.51:3000/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    Navigator.pop(context);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      var role = responseData['role'];
      var userId = responseData['userId'];

      print('Role: $role, UserID: $userId');

      if (role == 'admin') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen()));
      } else if (role == 'students') {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(userId: userId)));
      } else if (role == 'teachers') {
        print('Fetching teacher data for userId: $userId');
        var teacherData = await fetchTeacherData(userId);
        print('Teacher data: $teacherData');
        var teacher = Teacher.fromFirestore(teacherData);
        if (teacher.classesHomeroom.isNotEmpty &&
            teacher.classesSubject.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeroomTeacherDashboard(
                userId: userId,
                teacherData: teacher,
                selectedClass: teacher.classesHomeroom.first.classname,
              ),
            ),
          );
        } else if (teacher.classesSubject.isNotEmpty &&
            teacher.classesHomeroom.isEmpty) {
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
        } else if (teacher.classesHomeroom.isNotEmpty ||
            teacher.classesSubject.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClassSelectionPage(
                teacherData: teacher,
                userId: userId,
                isHomeroomTeacher: teacher.classesHomeroom.isNotEmpty,
              ),
            ),
          );
        } else {
          showErrorSnackBar(context, 'Teacher has no classes assigned.');
        }
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

Future<Map<String, dynamic>> fetchTeacherData(String userId) async {
  var url = Uri.parse('http://192.168.31.51:3000/teacher/$userId');
  var response = await http.get(url);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to fetch teacher data');
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
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hintText: "מייל",
                      fillColor: Colors.grey.shade100,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
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
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: GestureDetector(
                    onTap: logUserIn,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 53, 162, 212),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "כניסה",
                          style: GoogleFonts.notoSerifHebrew(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
