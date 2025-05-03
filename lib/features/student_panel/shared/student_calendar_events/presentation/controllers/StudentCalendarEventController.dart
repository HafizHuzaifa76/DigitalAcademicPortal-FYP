import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:digital_academic_portal/core/utils/Utils.dart';
import 'package:digital_academic_portal/shared/domain/entities/CalendarEvent.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../domain/usecases/GetAllCalendarEvents.dart';

class StudentCalendarEventController extends GetxController {
  
  final GetAllCalendarEvents getAllEvents;

  StudentCalendarEventController({required this.getAllEvents}); 


  // State variables
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;
  var calendarFormat = CalendarFormat.month.obs;
  var isLoading = false.obs;
  var isCalendarLoading = false.obs;
  var showAllEvents = true.obs;

  // Events fetched from Firebase
  var allEvents = <CalendarEvent>[].obs;
  var events = <DateTime, List<CalendarEvent>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllCalendarEvents();
  }

  /// Fetch events from Firebase
  Future<void> fetchAllCalendarEvents() async {
    isCalendarLoading(true);
    final result = await getAllEvents.execute(null);

    result.fold((left) {
      String message = left.failure.toString();
      Utils().showErrorSnackBar('Error', message);
    }, (eventMap) {
      events.value = eventMap;

      final now = DateTime.now();

      allEvents.addAll(
        events.values
            .expand((eventList) => eventList)
            .where((event) => event.date.isAfter(now) || event.date.day == now.day)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date)),
      );

      if (kDebugMode) {
        print('Events fetched successfully.');
      }
    });

    isCalendarLoading(false);
  }

  // Get events for a specific day
  List<CalendarEvent> getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  // Update selected day
  void onDaySelected(DateTime incomingSelectedDay, DateTime focusedDay) {
    selectedDay.value = incomingSelectedDay;
    this.focusedDay.value = focusedDay;
    showAllEvents(false); // Switch to show only selected day's events
  }

  /// Reset to show all events
  void resetToShowAllEvents() {
    showAllEvents(true);
  }
}
