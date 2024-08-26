import 'package:flutter/material.dart';
import 'package:frontend/Parent/ParentHomeScreen.dart';
import 'package:frontend/models/parentmodel.dart';

class ChildSelectionPage extends StatelessWidget {
  final Parent parent;

  const ChildSelectionPage({Key? key, required this.parent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Color> cardColors = [
      Color(0xFFE57373),
      Color.fromARGB(255, 233, 179, 31),
      Color(0xFF64B5F6),
      Color(0xFF4DB6AC),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'בחירת תלמיד',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Merienda',
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: parent.children.length,
        itemBuilder: (context, index) {
          final child = parent.children[index];
          final color = cardColors[index % cardColors.length];

          return GestureDetector(
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
            child: Card(
              color: color,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('asset/icons/user.png'),
                    radius: 30.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    child.fullname,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
