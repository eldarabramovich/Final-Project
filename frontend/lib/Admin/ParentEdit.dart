import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class EditParentPage extends StatefulWidget {
  final String userId;

  EditParentPage({required this.userId});

  @override
  _EditParentPageState createState() => _EditParentPageState();
}

class _EditParentPageState extends State<EditParentPage> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _childController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchParentData();
  }

  Future<void> fetchParentData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://${Config.baseUrl}/parent/getParentById/${widget.userId}'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          _fullnameController.text = data['fullname'];
          _usernameController.text = data['username'];
          _passwordController.text = data['password'];
          _childController.text =
              data['children'].map((child) => child['fullname']).join(', ');
          isLoading = false;
        });
      } else {
        print('Failed to load parent data: ${response.body}');
      }
    } catch (e) {
      print('Error fetching parent data: $e');
    }
  }

  Future<void> saveParentData() async {
    try {
      final response = await http.post(
        Uri.parse('http://${Config.baseUrl}/parent/updateParent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'id': widget.userId,
          'fullname': _fullnameController.text,
          'username': _usernameController.text,
          'password': _passwordController.text,
          // 'children': _childController.text.split(',').map((name) => {'fullname': name.trim()}).toList(),
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Parent updated successfully')));
      } else {
        print('Failed to save parent data: ${response.body}');
      }
    } catch (e) {
      print('Error saving parent data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Parent'),
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
                  // TextField(
                  //   controller: _childController,
                  //   decoration: InputDecoration(
                  //       labelText: 'Children (comma separated)'),
                  // ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: saveParentData,
                    child: Text('Save'),
                  ),
                ],
              ),
            ),
    );
  }
}
