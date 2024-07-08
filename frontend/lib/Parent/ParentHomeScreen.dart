import 'package:flutter/material.dart';

class ParentHomeScreen extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> childData;

  const ParentHomeScreen({Key? key, required this.userId, required this.childData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Home - ${childData['fullname']}'),
      ),
      body: Center(
        child: Text('Welcome ${childData['fullname']}\'s Parent!'),
      ),
    );
  }
}
