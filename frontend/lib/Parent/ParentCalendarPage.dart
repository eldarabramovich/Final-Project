/*
import 'package:flutter/material.dart';

class ParentCalendarPage extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> childData;

  const ParentCalendarPage({
    Key? key,
    required this.userId,
    required this.childData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Center(
        child: Text('Calendar for ${childData['fullname']}'),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class ParentCalendarPage extends StatelessWidget {
  final String userId;
  final Map<String, dynamic> childData;

  const ParentCalendarPage({
    Key? key,
    required this.userId,
    required this.childData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('he_IL', null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Calendar for ${childData['fullname']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _buildCalendar(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    return TableCalendar(
      locale: 'he_IL',
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: today,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
      ),
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue.shade200,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue.shade800,
          shape: BoxShape.circle,
        ),
        markersMaxCount: 1,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.black),
        weekendStyle: TextStyle(color: Colors.red),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          return Container(
            margin: const EdgeInsets.all(3.0),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              shape: BoxShape.circle,
            ),
          );
        },
      ),
      // Replace with actual events data
      eventLoader: (day) {
        return ['Event 1', 'Event 2']; // Example events for demonstration
      },
    );
  }
}

void main() {
  // Example child data
  Map<String, dynamic> childData = {
    'fullname': 'John Doe', // Replace with actual child's name
  };

  runApp(MaterialApp(
    home: ParentCalendarPage(
      userId: 'exampleUserId', // Replace with actual user ID
      childData: childData,
    ),
  ));
}
