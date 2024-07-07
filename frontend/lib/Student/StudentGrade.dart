/*
import 'package:flutter/material.dart';
import 'package:frontend/config.dart';
class StudentGrade extends StatelessWidget {
  const StudentGrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ציונים"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text("זה מסך של ציונים"),
      ),
    );
  }
}

*/

// pages/StudentGrade.dart
// pages/StudentGrade.dart

import 'package:flutter/material.dart';

class StudentGrade extends StatelessWidget {
  // Dummy data to simulate fetched grades
  final List<Map<String, dynamic>> grades = [
    {
      'subjectName': 'מתמטיקה',
      'grade': 95,
    },
    {
      'subjectName': 'אנגלית',
      'grade': 88,
    },
    {
      'subjectName': 'מדעים',
      'grade': 92,
    },
    {
      'subjectName': 'היסטוריה',
      'grade': 85,
    },
    {
      'subjectName': 'ספרות',
      'grade': 52,
    },
  ];

  // Calculate the average grade
  double get averageGrade {
    final total =
        grades.fold<int>(0, (sum, grade) => sum + grade['grade'] as int);
    return total / grades.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('הציונים שלי'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.blue.shade800,
            child: Column(
              children: [
                Text(
                  'ממוצע',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  averageGrade.toStringAsFixed(2),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final grade = grades[index];
                final gradeColor =
                    grade['grade'] > 56 ? Colors.green : Colors.red;

                return Card(
                  color: Colors.blue.shade50,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        ' ${grade['subjectName']}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    subtitle: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'ציון: ${grade['grade']}',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: gradeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
