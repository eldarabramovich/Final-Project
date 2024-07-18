import 'package:flutter/material.dart';
import 'package:frontend/Parent/ParentHomeScreen.dart';
import 'package:frontend/models/parentmodel.dart';

class ChildSelectionPage extends StatelessWidget {
  final Parent parent;

  const ChildSelectionPage({Key? key, required this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('בחר ילד'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: parent.children.length,
        itemBuilder: (context, index) {
          final child = parent.children[index];
          return ListTile(
            title: Text(child.fullname),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentDashboard(
                    parent: parent,
                    selectedChild: child,
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
