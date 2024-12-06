import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final List days;

  CalendarScreen({
    required this.days,
  });

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {

  late Map<DateTime, List<Map<String, dynamic>>> events;

  @override
  void initState() {
    super.initState();
    events = {};
    _populateEvents();

    print("Events" + events.toString());
  }

  void _populateEvents() {
    for (var item in widget.days) {
      DateTime day = DateTime.utc(item['day'].year, item['day'].month, item['day'].day);
      if (events.containsKey(day)) {
        events[day]!.add(item);
      } else {
        events[day] = [item];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance Calendar')),
      body: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2050, 12, 31),
        focusedDay: DateTime.now(),
        eventLoader: (day) {
          return events[DateTime.utc(day.year, day.month, day.day)] ?? [];
        },
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            if (events.isNotEmpty) {
              var event = events.first;
              if (event is Map<String, dynamic> && event.containsKey('isAttended')) {
                bool isAttended = event['isAttended'];
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isAttended ? Colors.green : Colors.red,
                  ),
                  width: 20,
                  height: 20,
                  child: Center(
                    child: isAttended
                        ? Icon(Icons.check, color: Colors.white, size: 10)
                        : Icon(Icons.cancel, color: Colors.white, size: 10),
                  ),
                );
              }
            }
            return null;
          },
        ),
      ),
    );
  }
}