import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Student/StudentHomeScreen.dart';
import 'package:frontend/Teacher/TeacherHomeScreen.dart';
import 'package:frontend/login_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        //what we check here is if there are any users that we add at our data
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const TeacherHomeScreen();
          } else {
            return const TeacherHomeScreen();
          }
        },
      ),
    );
  }
}
