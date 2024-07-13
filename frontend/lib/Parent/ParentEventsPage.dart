import 'package:flutter/material.dart';

class ParentEventsPage extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> childData;

  const ParentEventsPage({
    Key? key,
    required this.userId,
    required this.childData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: Center(
        child: Text('Events for ${childData['fullname']}'),
      ),
    );
  }
}
