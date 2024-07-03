/*
import 'package:flutter/material.dart';

class StudentCalendar extends StatelessWidget {
  const StudentCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("לוח שנה"),
        backgroundColor: Colors.blue.shade800,
      ),
      body: const Center(
        child: Text("זה מסך של לוח שנה"),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class StudentCalendar extends StatefulWidget {
  final String userId;

  const StudentCalendar({Key? key, required this.userId}) : super(key: key);

  @override
  _StudentCalendarState createState() => _StudentCalendarState();
}

class _StudentCalendarState extends State<StudentCalendar> {
  late Map<DateTime, List<String>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  TextEditingController eventController = TextEditingController();

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<String> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'לוח שנה של התלמיד',
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddEventDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: focusedDay,
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekVisible: true,
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
              },
              eventLoader: _getEventsFromDay,
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            ..._getEventsFromDay(selectedDay).map(
              (event) => ListTile(
                title: Text(event),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'הוסף אירוע',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        content: TextFormField(
          controller: eventController,
          decoration: InputDecoration(
            hintText: 'הכנס תיאור אירוע',
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'ביטול',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(
              'הוסף',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (eventController.text.isEmpty) return;
              setState(() {
                if (selectedEvents[selectedDay] != null) {
                  selectedEvents[selectedDay]!.add(eventController.text);
                } else {
                  selectedEvents[selectedDay] = [eventController.text];
                }
              });
              eventController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
