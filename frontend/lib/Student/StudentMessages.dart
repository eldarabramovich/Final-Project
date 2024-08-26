import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class StudentClassMessagesScreen extends StatefulWidget {
  final String userId;
  final String selectedClass;

  const StudentClassMessagesScreen(
      {Key? key, required this.userId, required this.selectedClass})
      : super(key: key);

  @override
  _StudentClassMessagesScreenState createState() =>
      _StudentClassMessagesScreenState();
}

class _StudentClassMessagesScreenState
    extends State<StudentClassMessagesScreen> {
  List<String> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      print('Fetching messages for class: ${widget.selectedClass}');
      var messagesResponse = await http.get(
        Uri.parse(
            'http://${Config.baseUrl}/student/getmess/${widget.selectedClass}'),
      );

      if (messagesResponse.statusCode == 200) {
        try {
          List<dynamic> messagesData = json.decode(messagesResponse.body);
          setState(() {
            _messages = List<String>.from(messagesData
                .map((message) => message['description'] as String));
            _isLoading = false;
          });
        } on FormatException catch (e) {
          print('Error parsing messages data: $e');
          _showError('Error parsing messages data');
        }
      } else {
        print('Failed to fetch messages: ${messagesResponse.statusCode}');
        print('Response body: ${messagesResponse.body}');
        _showError('Failed to fetch messages');
      }
    } catch (e, stacktrace) {
      print('An error occurred: $e');
      print('Stacktrace: $stacktrace');
      _showError('An error occurred while fetching data');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'הודעות מהמורה',
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _messages.isEmpty
              ? const Center(child: Text('No messages found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: _buildMessageBubble(_messages[index]),
                    );
                  },
                ),
    );
  }

  Widget _buildMessageBubble(String message) {
    return Align(
      alignment: Alignment.centerLeft, // Adjust for alignment
      child: Container(
        padding: const EdgeInsets.all(12.0),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.0,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: CustomPaint(
          painter: BubbleTailPainter(),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}

class BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade200
      ..style = PaintingStyle.fill;

    // Draw the main bubble
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height - 10)
      ..lineTo(10, size.height - 10)
      ..lineTo(0, size.height - 20)
      ..close();

    // Draw the tail
    final tailPath = Path()
      ..moveTo(size.width / 2 - 10, size.height)
      ..lineTo(size.width / 2 + 10, size.height)
      ..lineTo(size.width / 2, size.height + 10)
      ..close();

    canvas.drawPath(path, paint);
    canvas.drawPath(tailPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
