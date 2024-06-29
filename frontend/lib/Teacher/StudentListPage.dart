import 'package:flutter/material.dart';

class StudentListPage extends StatefulWidget {
  final String className;

  const StudentListPage({Key? key, required this.className}) : super(key: key);

  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  DateTime selectedDate = DateTime.now();
  // Mock data for demonstration
  List<String> students = [
    'Student 1',
    'Student 2',
    'Student 3',
    'Student 4',
    'Student 5',
  ];

  List<bool> isPresent = List.filled(5, false); // Assuming 5 students initially

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Text(
                'נא ללחוץ על הכפתור כדי לבחור התאריך המתאים',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width *
                  0.95, // 80% of the screen width
              child: TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  '${selectedDate.toString().substring(0, 10)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 150, 154, 158)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 252, 252, 252),
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        child: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          onPressed: () {
            for (int i = 0; i < students.length; i++) {
              print('${students[i]} is ${isPresent[i] ? 'present' : 'absent'}');
            }
          },
          label: Text('שמירה'),
          icon: Icon(Icons.save),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
