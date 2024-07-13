import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/config.dart';

class TeacherCalendar extends StatefulWidget {
  final String userId;

  const TeacherCalendar({Key? key, required this.userId}) : super(key: key);

  @override
  _TeacherCalendarState createState() => _TeacherCalendarState();
}

class _TeacherCalendarState extends State<TeacherCalendar> {
  late Map<DateTime, List<Map<String, dynamic>>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final response =
        await http.get(Uri.parse('http://${Config.baseUrl}:3000/getEvents'));

    if (response.statusCode == 200) {
      List<dynamic> eventsJson = json.decode(response.body);
      setState(() {
        selectedEvents = {
          for (var event in eventsJson)
            DateTime.parse(event['date']): [
              {
                'time': event['time'],
                'event': event['event'],
              }
            ]
        };
      });
    } else {
      print('Failed to load events');
    }
  }

  List<Map<String, dynamic>> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  Future<void> _addEvent() async {
    if (_eventController.text.isEmpty || _selectedTime == null) return;

    DateTime eventDate = DateTime(selectedDay.year, selectedDay.month,
        selectedDay.day, _selectedTime!.hour, _selectedTime!.minute);

    final response = await http.post(
      Uri.parse('http://${Config.baseUrl}:3000/addEvent'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'date': selectedDay.toIso8601String(),
        'time': DateFormat('HH:mm').format(eventDate),
        'event': _eventController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        if (selectedEvents[selectedDay] != null) {
          selectedEvents[selectedDay]!.add({
            'time': DateFormat('HH:mm').format(eventDate),
            'event': _eventController.text,
          });
        } else {
          selectedEvents[selectedDay] = [
            {
              'time': DateFormat('HH:mm').format(eventDate),
              'event': _eventController.text,
            }
          ];
        }
        _eventController.clear();
        _selectedTime = null;
        Navigator.pop(context);
      });
    } else {
      print('Failed to add event');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'יומן מורה',
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        backgroundColor: Colors.blue.shade800,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('הוסף אירוע'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _eventController,
                      decoration: InputDecoration(
                        labelText: 'תיאור אירוע',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Text(_selectedTime == null
                          ? 'בחר זמן'
                          : _selectedTime!.format(context)),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('ביטול'),
                  ),
                  TextButton(
                    onPressed: _addEvent,
                    child: Text('שמור'),
                  ),
                ],
                backgroundColor: Colors.blue.shade50,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
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
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          ..._getEventsFromDay(selectedDay).map(
            (event) => ListTile(
              title: Text(event['event']),
              subtitle: Text(event['time']),
            ),
          ),
        ],
      ),
    );
  }
}
