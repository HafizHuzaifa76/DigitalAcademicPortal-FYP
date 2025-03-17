import 'package:digital_academic_portal/features/administrator_panel/shared/calendar_events/domain/entities/CalendarEvent.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

import '../controllers/CalendarEventController.dart';

class CalendarEventPage extends StatefulWidget {
  const CalendarEventPage({super.key});

  @override
  State<CalendarEventPage> createState() => _CalendarEventPageState();
}

class _CalendarEventPageState extends State<CalendarEventPage> {
  final CalendarEventController _controller = Get.find();
  final primaryColor = Get.theme.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar Events'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditDialog(context),
        child: const Icon(Icons.add),
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
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _controller.deleteEvent(_controller.selectedDay.value, event),
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }

  // Add Event Dialog
  Future<void> _showAddEventDialog(BuildContext context) async {
    String? eventTitle;

    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: TextField(
            onChanged: (value) => eventTitle = value,
            decoration: const InputDecoration(hintText: 'Event Title'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (eventTitle != null && eventTitle!.trim().isNotEmpty) {
                  _controller.addEvent();
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showAddOrEditDialog(BuildContext context, {CalendarEvent? event}) {
    if (event != null) {
      _controller.updateEventDetails(event);
    } else {
      _controller.clearFields();
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(event == null ? "Add Event" : "Edit Event"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller.titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: _controller.categoryController,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return ListTile(
                  title: Text(
                    "Date: ${_controller.selectedDay.value.toLocal().toString().split(' ')[0]}",
                  ),
                  trailing: const Icon(Icons.calendar_today),
                );
              }),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                if (event == null) {
                  _controller.addEvent();
                } else {
                  final updatedEvent = CalendarEvent(
                    id: event.id,
                    title: _controller.titleController.text.trim(),
                    category: _controller.categoryController.text.trim(),
                    date: _controller.selectedDay.value,
                  );
                  _controller.editEvent(updatedEvent);
                }
                Navigator.of(ctx).pop();
              },
              child: Text(event == null ? "Add" : "Update"),
            ),
          ],
        );
      },
    );
  }
}
