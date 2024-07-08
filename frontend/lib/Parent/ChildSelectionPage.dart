import 'package:flutter/material.dart';
import 'package:frontend/Parent/ParentHomeScreen.dart';

class ChildSelectionPage extends StatelessWidget {
  final String userId;
  final List<Map<String, dynamic>> children;

  const ChildSelectionPage({Key? key, required this.userId, required this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Child'),
      ),
      body: ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          return ListTile(
            title: Text(child['fullname']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentHomeScreen(
                    userId: userId,
                    childData: child,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
