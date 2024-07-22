/*
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class EditStudentPage extends StatefulWidget {
  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _subClassNameController = TextEditingController();

  bool isLoading = false;

  Future<void> saveStudentData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/admin/updateStudent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'fullname': _fullnameController.text,
          'newUsername': _usernameController.text,
          'newPassword': _passwordController.text,
          'newClassname': _classNameController.text.isEmpty
              ? null
              : _classNameController.text,
          'newSubClassName': _subClassNameController.text.isEmpty
              ? null
              : _subClassNameController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student updated successfully')));
      } else {
        print('Failed to save student data: ${response.body}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to update student')));
      }
    } catch (e) {
      print('Error saving student data: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error updating student')));
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteStudent() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/admin/deleteStudent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'fullname': _fullnameController.text,
          'classname': _classNameController.text,
          'subClassName': _subClassNameController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student deleted successfully')));
        Navigator.pop(context); // Navigate back after deletion
      } else {
        print('Failed to delete student: ${response.body}');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to delete student')));
      }
    } catch (e) {
      print('Error deleting student: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error deleting student')));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Student'),
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
                    controller: _classNameController,
                    decoration: InputDecoration(labelText: 'Class Name'),
                  ),
                  TextField(
                    controller: _subClassNameController,
                    decoration: InputDecoration(labelText: 'Sub Class Name'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveStudentData,
                    child: Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: deleteStudent,
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

class EditStudentPage extends StatefulWidget {
  @override
  _EditStudentPageState createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();
  final TextEditingController _subClassNameController = TextEditingController();

  bool isLoading = false;

  Future<void> saveStudentData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      try {
        final response = await http.post(
          Uri.parse('http://${Config.baseUrl}/admin/updateStudent'),
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(<String, dynamic>{
            'fullname': _fullnameController.text,
            'newUsername': _usernameController.text,
            'newPassword': _passwordController.text,
            'newClassname': _classNameController.text.isEmpty
                ? null
                : _classNameController.text,
            'newSubClassName': _subClassNameController.text.isEmpty
                ? null
                : _subClassNameController.text,
          }),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('התלמיד עודכן בהצלחה')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('עדכון התלמיד נכשל: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('שגיאה בעדכון התלמיד: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> deleteStudent() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/admin/deleteStudent'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(<String, String>{
          'fullname': _fullnameController.text,
          'classname': _classNameController.text,
          'subClassName': _subClassNameController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('התלמיד נמחק בהצלחה')),
        );
        Navigator.pop(context); // Navigate back after deletion
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('מחיקת התלמיד נכשלה: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('שגיאה במחיקת התלמיד: $e')),
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
        title: Text('עריכת תלמיד', style: TextStyle(color: Colors.white)),
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
                        controller: _classNameController,
                        decoration: InputDecoration(
                          labelText: 'כיתת תלמיד חדשה',
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
                        controller: _subClassNameController,
                        decoration: InputDecoration(
                          labelText: 'תת כיתת תלמיד חדשה',
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
                          onPressed: saveStudentData,
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
                          onPressed: deleteStudent,
                          child: Text('מחק'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 248, 56, 45),
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
