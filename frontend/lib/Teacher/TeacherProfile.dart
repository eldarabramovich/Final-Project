import 'package:flutter/material.dart';

class TeacherProfile extends StatefulWidget {
  final String username;
  final String name;
  final String userClass;
  final String password;

  TeacherProfile({
    required this.username,
    required this.name,
    required this.userClass,
    required this.password,
  });

  @override
  _TeacherProfileState createState() => _TeacherProfileState();
}

class _TeacherProfileState extends State<TeacherProfile> {
  bool _isPasswordVisible = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'פרופיל משתמש',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileField(
              label: 'שם משתמש',
              value: widget.username,
            ),
            SizedBox(height: 20),
            ProfileField(
              label: 'שם',
              value: widget.name,
            ),
            SizedBox(height: 20),
            ProfileField(
              label: 'כיתה',
              value: widget.userClass,
            ),
            SizedBox(height: 20),
            ProfileField(
              label: 'סיסמא',
              value: _isPasswordVisible ? widget.password : '********',
              isPasswordField: true,
              onToggleVisibility: _togglePasswordVisibility,
              isPasswordVisible: _isPasswordVisible,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final bool isPasswordField;
  final VoidCallback? onToggleVisibility;
  final bool? isPasswordVisible;

  const ProfileField({
    Key? key,
    required this.label,
    required this.value,
    this.isPasswordField = false,
    this.onToggleVisibility,
    this.isPasswordVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (isPasswordField)
              IconButton(
                icon: Icon(
                  isPasswordVisible! ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: onToggleVisibility,
              ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
