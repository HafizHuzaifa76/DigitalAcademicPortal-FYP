
import 'package:digital_academic_portal/features/student_panel/shared/student_calendar_events/presentation/controllers/StudentCalendarEventController.dart';
import 'package:digital_academic_portal/shared/domain/entities/CalendarEvent.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

class StudentCalendarPage extends StatefulWidget {
  const StudentCalendarPage({super.key});

  @override
  State<StudentCalendarPage> createState() => _StudentCalendarPageState();
}

class _StudentCalendarPageState extends State<StudentCalendarPage> {
  final StudentCalendarEventController _controller = Get.find();
  final primaryColor = Get.theme.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Events'),
      ),
      body: Obx((){
        return _controller.isCalendarLoading.value ?
          Center(child: Lottie.asset('assets/animations/loading_animation4.json', width: 120, height: 120, fit: BoxFit.scaleDown,))
            : Column(
              children: [
                _buildCalendarView(),
                const SizedBox(height: 8.0),
                Text('Events', style: TextStyle(color: primaryColor, fontFamily: 'Ubuntu', fontSize: 23, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Divider(color: primaryColor, thickness: 4),
                ),
                Expanded(child: _buildEventListView()),
              ],
            );
      })
    );
  }

  // Calendar Widget
  Widget _buildCalendarView() {
    return Obx(() {
      return TableCalendar<CalendarEvent>(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: _controller.focusedDay.value,
        selectedDayPredicate: (day) => isSameDay(_controller.selectedDay.value, day),
        onDaySelected: _controller.onDaySelected,
        calendarFormat: _controller.calendarFormat.value,
        onFormatChanged: (format) => _controller.calendarFormat.value = format,
        onPageChanged: (focusedDay) => _controller.focusedDay.value = focusedDay,
        eventLoader: _controller.getEventsForDay,
      );
    });
  }

  Widget _buildEventListView() {
    return Obx(() {
      if (_controller.isLoading.value) {
        return Center(
          child: Lottie.asset(
            'assets/animations/loading_animation4.json',
            width: 60,
            height: 60,
            fit: BoxFit.scaleDown,
          ),
        );
      } else {
        final events = _controller.showAllEvents.value ? _controller.allEvents.value : _controller.getEventsForDay(_controller.selectedDay.value);
        if (events.isEmpty) {
          return Center(child: Text(_controller.showAllEvents.value ? 'No events added' : 'No events for this day.'));
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Date: ${event.date.day}-${event.date.month}-${event.date.year} ', style: const TextStyle(fontWeight: FontWeight.w500)),
                        Container(width: 2, height: 15, color: Colors.grey.shade700,),
                        Text(' ${event.category}', style: const TextStyle(fontWeight: FontWeight.w500)),
                      ],
                    ),
                ),
              );
            },
          ),
        );
      }
    });
  }

}