import 'package:flutter/material.dart';
import 'package:frontend/Parent/ParentHomeScreen.dart';

class ChildSelectionPage extends StatelessWidget {
  final String userId;
  final List<Map<String, dynamic>> children;

  const ChildSelectionPage({
    Key? key,
    required this.userId,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('בחר ילד'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: children.length,
          itemBuilder: (context, index) {
            final child = children[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child['fullname'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right, // Align text to the right
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: const Size(
                            double.infinity, 36), // Full width button
                      ),
                      child: const Text('בחר'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
