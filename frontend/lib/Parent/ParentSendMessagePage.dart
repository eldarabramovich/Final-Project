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