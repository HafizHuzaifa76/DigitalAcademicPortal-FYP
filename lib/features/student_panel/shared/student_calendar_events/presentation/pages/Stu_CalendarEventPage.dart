// calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Stu_CalendarScreen extends StatefulWidget {
  const Stu_CalendarScreen({super.key});

  @override
  State<Stu_CalendarScreen> createState() => _Stu_CalendarScreen();
}

class _Stu_CalendarScreen extends State<Stu_CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Calendar'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: const CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
