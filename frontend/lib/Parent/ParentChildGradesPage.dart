/*
import 'package:flutter/material.dart';

class ParentChildGradesPage extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> childData;

  const ParentChildGradesPage({
    Key? key,
    required this.userId,
    required this.childData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Child Grades - ${childData['fullname']}'),
      ),
      body: Center(
        child: Text(
          'Grades page for ${childData['fullname']}',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}


*/
import 'package:flutter/material.dart';

class ParentChildGradesPage extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> childData;

  const ParentChildGradesPage({
    Key? key,
    required this.userId,
    required this.childData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock list of grades data
    List<Map<String, dynamic>> gradesData = [
      {'subject': 'Math', 'grade': 90},
      {'subject': 'Science', 'grade': 85},
      {'subject': 'History', 'grade': 92},
      {'subject': 'English', 'grade': 88},
      {'subject': 'Art', 'grade': 95},
    ];

    // Calculate average grade
    double averageGrade = _calculateAverageGrade(gradesData);

    return Scaffold(
      appBar: AppBar(
        title: Text('${childData['fullname']}\'s Grades'),
        backgroundColor: Colors.blue.shade800, // Setting app bar color
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Average Grade: ${averageGrade.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: gradesData.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text('${gradesData[index]['subject']}'),
                      subtitle: Text('Grade: ${gradesData[index]['grade']}'),
                      leading: CircleAvatar(
                        child: Text('${gradesData[index]['grade']}'),
                      ),
                      trailing: Icon(Icons.grade), // Example icon
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to calculate average grade
  double _calculateAverageGrade(List<Map<String, dynamic>> grades) {
    if (grades.isEmpty) return 0.0;

    double total = 0.0;
    for (var grade in grades) {
      total += grade['grade'];
    }
    return total / grades.length;
  }
}

void main() {
  // Example child data
  Map<String, dynamic> childData = {
    'fullname': 'John Doe', // Replace with actual child's name
  };

  runApp(MaterialApp(
    home: ParentChildGradesPage(
      userId: 'exampleUserId', // Replace with actual user ID
      childData: childData,
    ),
  ));
}
