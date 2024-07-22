/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class EditTeacherPage extends StatefulWidget {
  @override
  _EditTeacherPageState createState() => _EditTeacherPageState();
}

class _EditTeacherPageState extends State<EditTeacherPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _classHomeroomController =
      TextEditingController();
  final TextEditingController _classesSubjectController =
      TextEditingController();

  bool isLoading = false;

  Future<void> saveTeacherData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/admin/updateTeacher'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'fullname': _fullnameController.text,
          'newUsername': _usernameController.text,
          'newPassword': _passwordController.text,
          'newEmail': _emailController.text,
          'newClassHomeroom': _classHomeroomController.text.trim().isEmpty
              ? null
              : _classHomeroomController.text.trim(),
          'newClassesSubject': _classesSubjectController.text.trim().isEmpty
              ? []
              : _classesSubjectController.text.split(',').map((subject) {
                  var parts = subject.split('-');
                  return {
                    'classname': parts[0].trim(),
                    'subjectname': parts[1].trim(),
                  };
                }).toList(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Teacher updated successfully')));
      } else {
        print('Failed to save teacher data: ${response.body}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update teacher')));
      }
    } catch (e) {
      print('Error saving teacher data: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating teacher')));
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteTeacher() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/admin/deleteTeacher'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'fullname': _fullnameController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Teacher deleted successfully')));
        Navigator.pop(context); // Navigate back after deletion
      } else {
        print('Failed to delete teacher: ${response.body}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to delete teacher')));
      }
    } catch (e) {
      print('Error deleting teacher: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting teacher')));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Teacher'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(
                    controller: _fullnameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: _classHomeroomController,
                    decoration: InputDecoration(
                        labelText: 'Class Homeroom (comma separated)'),
                  ),
                  TextField(
                    controller: _classesSubjectController,
                    decoration: InputDecoration(
                        labelText:
                            'Classes and Subjects (format: classname-subjectname, separated by commas)'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveTeacherData,
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: deleteTeacher,
                    child: Text('Delete'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class EditTeacherPage extends StatefulWidget {
  @override
  _EditTeacherPageState createState() => _EditTeacherPageState();
}

class _EditTeacherPageState extends State<EditTeacherPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _classHomeroomController =
      TextEditingController();
  final TextEditingController _classesSubjectController =
      TextEditingController();

  bool isLoading = false;

  Future<void> saveTeacherData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://${Config.baseUrl}/admin/updateTeacher'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'fullname': _fullnameController.text,
            'newUsername': _usernameController.text,
            'newPassword': _passwordController.text,
            'newEmail': _emailController.text,
            'newClassHomeroom': _classHomeroomController.text.trim().isEmpty
                ? null
                : _classHomeroomController.text.trim(),
            'newClassesSubject': _classesSubjectController.text.trim().isEmpty
                ? []
                : _classesSubjectController.text.split(',').map((subject) {
                    var parts = subject.split('-');
                    return {
                      'classname': parts[0].trim(),
                      'subjectname': parts[1].trim(),
                    };
                  }).toList(),
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('המורה עודכן בהצלחה')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('עדכון המורה נכשל: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בעדכון המורה: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> deleteTeacher() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/admin/deleteTeacher'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'fullname': _fullnameController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('המורה נמחק בהצלחה')),
        );
        Navigator.pop(context); // Navigate back after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('מחיקת המורה נכשלה: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('שגיאה במחיקת המורה: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('עריכת מורה', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _fullnameController,
                        decoration: InputDecoration(
                          labelText: 'שם מלא',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'נא להזין שם מלא';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'שם משתמש חדש',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'נא להזין שם משתמש חדש';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'סיסמה חדשה',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'נא להזין סיסמה חדשה';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'אימייל',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'נא להזין אימייל';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _classHomeroomController,
                        decoration: InputDecoration(
                          labelText: 'כיתת אם (מופרדת בפסיקים)',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _classesSubjectController,
                        decoration: InputDecoration(
                          labelText:
                              'כיתות ומקצועות (פורמט: כיתה-מקצוע, מופרד בפסיקים)',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                        ),
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: saveTeacherData,
                          child: Text('שמור'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 214, 220, 227),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: deleteTeacher,
                          child: Text('מחק'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
