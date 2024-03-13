import 'package:flutter/material.dart';

class StudentListPage extends StatefulWidget {
  final String className;

  const StudentListPage({Key? key, required this.className}) : super(key: key);

  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  // Mock data for demonstration
  List<String> students = [
    'Student 1',
    'Student 2',
    'Student 3',
    'Student 4',
    'Student 5',
  ];

  List<bool> isPresent = List.filled(5, false); // Assuming 5 students initially

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'תלמידי כיתה ${widget.className}',
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),

      body: Container(
        color: const Color.fromARGB(
            255, 252, 252, 252), // Light blue color for background
        child: ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            var studentName = students[index];
            return ListTile(
              title: Text(studentName),
              trailing: Checkbox(
                value: isPresent[index],
                onChanged: (newValue) {
                  setState(() {
                    isPresent[index] = newValue!;
                  });
                },
              ),
              // Add more information about the student if needed
            );
          },
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width *
            0.85, // Set width to 80% of screen width
        child: FloatingActionButton.extended(
          backgroundColor: Colors.blue, // Blue color for button
          onPressed: () {
            // Save the presence data or perform any action
            // For demonstration, print the presence status
            for (int i = 0; i < students.length; i++) {
              print('${students[i]} is ${isPresent[i] ? 'present' : 'absent'}');
            }
          },
          label: Text('שמירה'),
          icon: Icon(Icons.save),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // Center the button horizontally
    );
  }
}
