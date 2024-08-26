/*
import 'package:flutter/material.dart';
import 'package:frontend/models/parentmodel.dart';

class ParentSendMessagePage extends StatelessWidget {
  final String userId;
  final Children selectedChild;

  const ParentSendMessagePage({
    required this.userId,
    required this.selectedChild,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    void sendMessage() {
      String message = messageController.text.trim();
      // Implement logic to send message here
      // Optionally, you can clear the text field after sending
      messageController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Send Message'),
        backgroundColor: Colors.blue.shade800, // Setting app bar color
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send message to  teacher',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: sendMessage,
                child: Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


*/

import 'package:flutter/material.dart';
import 'package:frontend/models/parentmodel.dart';

class ParentSendMessagePage extends StatelessWidget {
  final String userId;
  final Children selectedChild;

  const ParentSendMessagePage({
    required this.userId,
    required this.selectedChild,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    void sendMessage() {
      String message = messageController.text.trim();
      // Implement logic to send message here
      // Optionally, you can clear the text field after sending
      messageController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        /*
        title: Text(
          'שלח הודעה למורה',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        */

        backgroundColor: Colors.blue.shade900,
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
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${selectedChild.fullname} הודעה למורה של',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: messageController,
              maxLines: 5,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'כתוב את ההודעה שלך כאן...',
                hintStyle: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: sendMessage,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blue.shade900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadowColor: Colors.black26,
                  elevation: 5,
                ),
                child: Text(
                  'שלח הודעה',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
