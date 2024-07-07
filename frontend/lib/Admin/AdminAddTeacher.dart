import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';
class AdminAddTeacher extends StatefulWidget {
  const AdminAddTeacher({super.key});

  @override
  _AdminAddTeacher createState() => _AdminAddTeacher();
}

class _AdminAddTeacher extends State<AdminAddTeacher> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final List<Map<String, String>> _selectedClassesSubjects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'הוספת מורה חדש',
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 17.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(12),
                ),
                fillColor: Colors.grey.shade100,
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(height: 16.0),
            Text('בחר כיתה ונושא:'),
            SizedBox(height: 10.0),
            Wrap(
              children: List<Widget>.generate(
                _selectedClassesSubjects.length,
                (index) => Chip(
                  label: Text(
                      '${_selectedClassesSubjects[index]['classname']} - ${_selectedClassesSubjects[index]['subject']}'),
                  onDeleted: () {
                    setState(() {
                      _selectedClassesSubjects.removeAt(index);
                    });
                  },
                ),
              ).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                _showClassSubjectDialog();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
              ),
              child: Text(
                'הוספת כיתה ונושא', // Text in Hebrew
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 17.0),
            ElevatedButton(
              onPressed: _saveTeacher,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue, // Text color
              ),
              child: Text(
                'שמור מורה', // Text in Hebrew
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClassSubjectDialog() {
    TextEditingController classController = TextEditingController();
    TextEditingController subjectController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Class and Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: classController,
                decoration: const InputDecoration(labelText: 'Class Name'),
              ),
              TextField(
                controller: subjectController,
                decoration: const InputDecoration(labelText: 'Subject'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedClassesSubjects.add({
                    'classname': classController.text,
                    'subject': subjectController.text,
                  });
                });
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _saveTeacher() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String fullName = _fullNameController.text;
    String email = _emailController.text;

    var url = Uri.parse(
        'http://10.0.0.22:3000/admin/addteacher'); // Replace with your actual endpoint
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'fullname': fullName,
        'email': email,
        'classes': _selectedClassesSubjects,
      }),
    );

    if (response.statusCode == 200) {
      // Teacher added successfully
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher added successfully')));
      Navigator.pop(context); // Navigate back to the previous screen
    } else {
      // Error adding teacher
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding teacher: ${response.body}')));
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

























































// class AdminAddTeacher extends StatefulWidget {
//   @override
//   _AdminAddTeacher createState() => _AdminAddTeacher();
// }

// class _AdminAddTeacher extends State<AdminAddTeacher> {
//   TextEditingController _usernameController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   TextEditingController _subjectController = TextEditingController();
//   TextEditingController _fullNameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   List<String> _selectedClasses = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Teacher'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             TextField(
//               controller: _subjectController,
//               decoration: InputDecoration(labelText: 'Subject'),
//             ),
//             TextField(
//               controller: _fullNameController,
//               decoration: InputDecoration(labelText: 'Full Name'),
//             ),
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 16.0),
//             Text('Select Classes:'),
//             Wrap(
//               children: List<Widget>.generate(
//                 _selectedClasses.length,
//                 (index) => Chip(
//                   label: Text(_selectedClasses[index]),
//                   onDeleted: () {
//                     setState(() {
//                       _selectedClasses.removeAt(index);
//                     });
//                   },
//                 ),
//               ).toList(),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 _showClassDialog();
//               },
//               child: Text('Add Class'),
//             ),
//             SizedBox(height: 16.0),
//             Container(
//               margin: EdgeInsets.only(left: 20.0, right: 20.0),
//               width: double.infinity,
//               height: 60.0,
//               decoration: BoxDecoration(
//                 color: Colors.blue, // Background color set to blue
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Perform save operation here
//                   _saveTeacher();
//                   // Navigate to admin home screen
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => AdminAddTeacher()),
//                   );
//                 },
//                 style: ElevatedButton.styleFrom(
//                   // primary: Colors.transparent, // Make the button transparent
//                   shadowColor: Colors.transparent, // Remove shadow
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                   ),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Spacer(),
//                     Text(
//                       'כניסה',
//                       style: Theme.of(context).textTheme.subtitle2!.copyWith(
//                             fontWeight: FontWeight.w500,
//                             fontSize: 16.0,
//                             color: Colors.white, // Text color set to white
//                           ),
//                     ),
//                     Spacer(),
//                     Icon(
//                       Icons.arrow_forward_outlined,
//                       size: 30.0,
//                       color: Colors.white, // Icon color set to white
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showClassDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Add Class'),
//           content: TextField(
//             decoration: InputDecoration(labelText: 'Class Name'),
//             onSubmitted: (value) {
//               setState(() {
//                 _selectedClasses.add(value);
//               });
//               Navigator.pop(context);
//             },
//           ),
//         );
//       },
//     );
//   }

//   void _saveTeacher() {
//     // Save the teacher details
//     String username = _usernameController.text;
//     String password = _passwordController.text;
//     String subject = _subjectController.text;
//     String fullName = _fullNameController.text;
//     String email = _emailController.text;
//     List<String> classes = _selectedClasses;

//     // You can now use these values to save the teacher
//     // For example, you can call an API or save to a database
//     // Don't forget to validate the data before saving
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     _subjectController.dispose();
//     _fullNameController.dispose();
//     _emailController.dispose();
//     super.dispose();
//   }
// }