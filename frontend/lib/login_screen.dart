// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding and decoding
import 'package:frontend/Admin/AdminHomeScreen.dart';
import 'package:frontend/Student/StudentHomeScreen.dart';
import 'package:frontend/Teacher/TeacherHomeScreen.dart';
import 'package:frontend/models/teachermodel.dart';
import 'package:frontend/Teacher/TeacherHomeScreen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  Future<Teacher?> fetchTeacherData(String userId) async {
    var url = Uri.parse('http://10.100.102.3:3000/teacher/$userId'); // Replace with your actual endpoint
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return Teacher.fromFirestore(data);
    } else {
      print('Failed to fetch teacher data');
      return null;
    }
  }



  void logUserIn() async {
    // Show a loading dialog
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Prepare the request body
    var requestBody = json.encode({
      'username': emailController.text,
      'password': passwordController.text,
    });

    // Make the HTTP POST request
    try {
      var response = await http.post(
        Uri.parse('http://10.100.102.3:3000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      // Remove the loading dialog
      Navigator.pop(context);

      // Check the response status and handle accordingly
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        var token = responseData['token'];
        var role = responseData['role'];
        var userId = responseData['userId'];

        if (role == 'admin') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AdminHomeScreen()), // Replace with your admin dashboard screen widget
          );
        } else if (role == 'students') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                    userId:
                        userId)), // Replace with your admin dashboard screen widget
          );
        } else if (role == 'teachers') {
          Teacher? teacher = await fetchTeacherData(userId);
         if (teacher != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TeacherHomeScreen(teacher: teacher)), // Replace with your admin dashboard screen widget
          );
        }
      } else {
        showErrorSnackBar(
            context, 'Login failed. Please check your credentials.');
      }
    } catch (error) {
      // Remove the loading dialog
      Navigator.pop(context);
      print('Error logging in: $error');
      // Handle network error
      showErrorSnackBar(context, 'Network error. Please try again later.');
    }
  }
  
  
  


















  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
      ),
    );
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

              //The Username/Email textfield

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

              const SizedBox(
                height: 10,
              ),

              //The Password textfield

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

              const SizedBox(
                height: 25,
              ),

              //the login button
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
      )),
    );
  }



  
}
