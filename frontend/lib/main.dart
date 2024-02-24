import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:frontend/Admin/AdminHomeScreen.dart';
import 'package:frontend/auth_page.dart';
import 'package:frontend/login_screen.dart';
//import 'firebase_options.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeachTouch',

      // Define the initial route to your first page
      initialRoute: '/login_screen',

      routes: {
        // Define routes
        '/login_screen': (context) => LoginScreen(),
        // You can define more routes here if neecdded
      },

      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white, primaryColor: Colors.white),
      //initialRoute: LoginScreen.routeName,
    );

    //initialRoute: LoginScreen.routeName;
  }
}
