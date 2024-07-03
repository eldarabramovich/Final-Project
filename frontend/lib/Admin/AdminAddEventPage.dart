import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AdminAddEventPage extends StatefulWidget {
  @override
  _AdminAddEventPageState createState() => _AdminAddEventPageState();
}

class _AdminAddEventPageState extends State<AdminAddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _infoController = TextEditingController();
  List<File> _selectedImages = [];

  Future<void> _pickImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages = pickedFiles.map((file) => File(file.path)).toList();
      });
    }
  }

  void _postEvent() {
    if (_formKey.currentState!.validate()) {
      // Implement the logic to post the event to the backend
      // For now, just clear the form and show a snackbar
      _formKey.currentState!.reset();
      _titleController.clear();
      _infoController.clear();
      setState(() {
        _selectedImages = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event posted successfully')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('הוסף אירוע חדש', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'כותרת האירוע',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'נא להזין כותרת לאירוע';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _infoController,
                  decoration: InputDecoration(
                    labelText: 'מידע על האירוע',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    fillColor: Colors.grey.shade100,
                    filled: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'נא להזין מידע על האירוע';
                    }
                    return null;
                  },
                  maxLines: 5,
                ),
                SizedBox(height: 20),
                Text(
                  'תמונות נבחרות:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImages,
                      icon: Icon(Icons.photo),
                      label: Text('בחר תמונות'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 214, 220, 227),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _selectedImages.isEmpty
                    ? Text('לא נבחרו תמונות')
                    : Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _selectedImages
                            .map((image) => Stack(
                                  children: [
                                    Image.file(
                                      image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImages.remove(image);
                                          });
                                        },
                                        child: Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                            .toList(),
                      ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _postEvent,
                    child: Text('פרסם אירוע'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 214, 220, 227),
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(0, 0, 0, 0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
