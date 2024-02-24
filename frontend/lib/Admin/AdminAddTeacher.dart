import 'package:flutter/material.dart';

class AdminAddTeacher extends StatefulWidget {
  @override
  _AdminAddTeacher createState() => _AdminAddTeacher();
}

class _AdminAddTeacher extends State<AdminAddTeacher> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  List<String> _selectedClasses = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Teacher'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
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
              controller: _subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            Text('Select Classes:'),
            Wrap(
              children: List<Widget>.generate(
                _selectedClasses.length,
                (index) => Chip(
                  label: Text(_selectedClasses[index]),
                  onDeleted: () {
                    setState(() {
                      _selectedClasses.removeAt(index);
                    });
                  },
                ),
              ).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                _showClassDialog();
              },
              child: Text('Add Class'),
            ),
            SizedBox(height: 16.0),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              width: double.infinity,
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.blue, // Background color set to blue
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Perform save operation here
                  _saveTeacher();
                  // Navigate to admin home screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminAddTeacher()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  // primary: Colors.transparent, // Make the button transparent
                  shadowColor: Colors.transparent, // Remove shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Text(
                      'כניסה',
                      style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: Colors.white, // Text color set to white
                          ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_outlined,
                      size: 30.0,
                      color: Colors.white, // Icon color set to white
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Class'),
          content: TextField(
            decoration: InputDecoration(labelText: 'Class Name'),
            onSubmitted: (value) {
              setState(() {
                _selectedClasses.add(value);
              });
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _saveTeacher() {
    // Save the teacher details
    String username = _usernameController.text;
    String password = _passwordController.text;
    String subject = _subjectController.text;
    String fullName = _fullNameController.text;
    String email = _emailController.text;
    List<String> classes = _selectedClasses;

    // You can now use these values to save the teacher
    // For example, you can call an API or save to a database
    // Don't forget to validate the data before saving
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _subjectController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
