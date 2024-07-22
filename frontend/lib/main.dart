import 'package:flutter/material.dart';
import 'package:frontend/Admin/AdminHomeScreen.dart';
import 'package:frontend/login_screen.dart';
import 'package:table_calendar/table_calendar.dart'; // Import the table_calendar package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
