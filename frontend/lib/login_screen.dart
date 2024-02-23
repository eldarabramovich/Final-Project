// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passeordController = TextEditingController();

  void logUserIn() async {
    //adding a loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    //check the user's data if is correct
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passeordController.text,
      );
      Navigator.pop(context); // Remove the loading dialog
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Remove the loading dialog
      if (e.code == 'user-not-found') {
        showErrorSnackBar(context, 'No user found with this email.');
      } else if (e.code == 'wrong-password') {
        showErrorSnackBar(context, 'Wrong password provided.');
      }
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
                  controller: passeordController,
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
