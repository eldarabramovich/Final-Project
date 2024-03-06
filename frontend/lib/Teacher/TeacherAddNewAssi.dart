import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/models/assigmentmodel.dart';

class TeacherAddNewAssi extends StatefulWidget {
  const TeacherAddNewAssi({Key? key}) : super(key: key);

  @override
  State<TeacherAddNewAssi> createState() => _NewAssignmentScreenState();
}

class _NewAssignmentScreenState extends State<TeacherAddNewAssi> {
  final _formKey = GlobalKey<FormState>();
  final _classnameController = TextEditingController();
  final _subjectnameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lastDateController = TextEditingController();

  Future<void> _submitAssignment() async {
    if (_formKey.currentState!.validate()) {
      AssignmentData newAssignment = AssignmentData(
        classname: _classnameController.text,
        subjectname: _subjectnameController.text,
        description: _descriptionController.text,
        lastDate: _lastDateController.text,
      );

      var url = Uri.parse(
          'http://10.100.102.3:3000/teacher/addassi'); // Replace with your actual endpoint
      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'classname': newAssignment.classname,
          'subjectname': newAssignment.subjectname,
          'description': newAssignment.description,
          'lastDate': newAssignment.lastDate,
        }),
      );

      if (response.statusCode == 200) {
        // Assignment added successfully
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Assignment added successfully')));
        Navigator.pop(context);
      } else {
        // Error adding assignment
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error adding assignment')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Assignment'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _classnameController,
                decoration: InputDecoration(labelText: 'Classname'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a classname';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _subjectnameController,
                decoration: InputDecoration(labelText: 'Subject Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastDateController,
                decoration: InputDecoration(labelText: 'Last Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a last date';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _submitAssignment,
                child: Text('Submit Assignment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// final _subjectController = TextEditingController();
//   final _descriptionController = TextEditingController();

//   // Selected class and due date variables
//   String? _selectedClass;
//   DateTime? _selectedDueDate;

//   // List of available classes
//   final List<String> _classes = [
//     'Class 1',
//     'Class 2',
//     'Class 3'
//   ]; // Add your actual classes

//   // Error handling flag
//   bool _hasError = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('New Assignment'),
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: GlobalKey<FormState>(), // For Form validation
//             autovalidateMode:
//                 AutovalidateMode.onUserInteraction, // Validate on interaction
//             child: Column(
//               children: [
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 // Dropdown menu for class selection
//                 DropdownButtonFormField<String>(
//                   value: _selectedClass,
//                   isExpanded: true, // Optional: Full width dropdown
//                   icon: const Icon(Icons.arrow_drop_down),
//                   items: _classes.map((String classId) {
//                     return DropdownMenuItem<String>(
//                       value: classId,
//                       child: Text(classId),
//                     );
//                   }).toList(),
//                   onChanged: (String? newClassId) {
//                     setState(() {
//                       _selectedClass = newClassId;
//                       _hasError = false; // Clear error on class selection
//                     });
//                   },
//                   validator: (String? value) {
//                     if (value == null) {
//                       return 'Please select a class';
//                     }
//                     return null;
//                   },
//                   hint: const Text('בחירת כיתה'),
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 // Subject text input
//                 TextFormField(
//                   controller: _subjectController,
//                   decoration: const InputDecoration(
//                     labelText: 'מקצוע',
//                     enabledBorder: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(),
//                     ),
//                   ),
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Subject is required';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(
//                   height: 10,
//                 ),

//                 // Description text input
//                 TextFormField(
//                   controller: _descriptionController,
//                   decoration: const InputDecoration(
//                     labelText: 'הסבר על המטלה',
//                     enabledBorder: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Color(0xFF345FB4)),
//                     ),
//                   ),
//                   maxLines: 5, // Adjust as needed for longer descriptions
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Description is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 // Due date picker

//                 /*
                
//                 TextButton(
//                   onPressed: () async {
//                     DateTime? newDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime(2025), // Adjust as needed
//                     );
//                     if (newDate != null) {
//                       setState(() {
//                         _selectedDueDate = newDate;
//                         _hasError = false; // Clear error on date selection
//                       });
//                     }
//                   },
//                 ),
                
                
//                 */
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   controller: _subjectController,
//                   decoration: const InputDecoration(
//                     labelText: 'מועד אחרון להגשת המטלה',
//                     enabledBorder: OutlineInputBorder(),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(),
//                     ),
//                   ),
//                   validator: (String? value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Subject is required';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 25,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: GestureDetector(
//                     child: Container(
//                       padding: EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: const Color.fromARGB(255, 53, 162, 212),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "שלח",
//                           style: GoogleFonts.notoSerifHebrew(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 18,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }