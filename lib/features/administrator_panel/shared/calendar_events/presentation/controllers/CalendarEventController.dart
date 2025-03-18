import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/calendar_events/domain/entities/CalendarEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../../core/utils/Utils.dart';
import '../../domain/usecases/AddCalendarEventUseCase.dart';
import '../../domain/usecases/AllCalendarEventUseCase.dart';
import '../../domain/usecases/DeleteCalendarEventUseCase.dart';
import '../../domain/usecases/EditCalendarEventUseCase.dart';

class CalendarEventController extends GetxController {
  final AllCalendarEventsUseCase fetchCalendarEventsUseCase;
  final AddCalendarEventUseCase addCalendarEventUseCase;
  final EditCalendarEventUseCase updateCalendarEventUseCase;
  final DeleteCalendarEventUseCase deleteCalendarEventUseCase;

  CalendarEventController({required this.fetchCalendarEventsUseCase, required this.addCalendarEventUseCase, required this.updateCalendarEventUseCase, required this.deleteCalendarEventUseCase}); // Error message state

  // Firestore reference
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // Text Editing Controllers for Input Fields
  var titleController = TextEditingController();
  var categoryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllCalendarEvents();
  }

  /// Fetch events from Firebase
  Future<void> fetchAllCalendarEvents() async {
    isCalendarLoading(true);
    final result = await fetchCalendarEventsUseCase.execute(null);

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

  Future<void> fetchEventsFromFirebase() async {
    final snapshot = await _firestore.collection('events').get();
    final eventMap = <DateTime, List<CalendarEvent>>{};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final eventDate = DateTime.parse(data['date']);
      final event = CalendarEvent(
        id: doc.id,
        title: data['title'],
        date: eventDate, category: '',
      );

      if (eventMap[eventDate] == null) {
        eventMap[eventDate] = [];
      }
      eventMap[eventDate]!.add(event);
    }
  }

  Future<void> addEvent() async {
    EasyLoading.show(status: 'Adding...');

    var newEvent = CalendarEvent(
      id: '',
      title: titleController.text.trim(),
      category: categoryController.text.trim(),
      date: selectedDay.value,
    );

    try {
      isLoading(true);
      final result = await addCalendarEventUseCase.execute(newEvent);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
        if (kDebugMode) {
          print(message);
        }
      }, (event) {
        final eventDate = selectedDay.value;
        if (events[eventDate] == null) {
          events[eventDate] = [];
        }

        events[eventDate]!.add(event);
        update();

        Utils().showSuccessSnackBar('Success', 'Event added successfully.');
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  /// Delete event from Firebase
  Future<void> deleteEvent(DateTime day, CalendarEvent event) async {
    EasyLoading.show(status: 'Deleting...');
    try {
      isLoading(true);
      final result = await deleteCalendarEventUseCase.execute(event);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);
      }, (right) {

        if (events[day] != null) {
          events[day]!.remove(event);
          if (events[day]!.isEmpty) {
            events.remove(day);
          }
        }
        update();

        Utils().showSuccessSnackBar('Success', 'Event deleted successfully.');
      });
    } finally {
      isLoading(false);
      EasyLoading.dismiss();
    }
  }

  /// Edit event in Firebase
  Future<void> editEvent(CalendarEvent updatedEvent) async {
    EasyLoading.show(status: 'Updating...');
    try {
      isLoading(true);
      final result = await updateCalendarEventUseCase.execute(updatedEvent);

      result.fold((left) {
        String message = left.failure.toString();
        Utils().showErrorSnackBar('Error', message);

      }, (right) {

        final oldDate = events.keys.firstWhere((date) =>
            events[date]!.any((e) => e.id == updatedEvent.id));

        // Remove from old date
        events[oldDate]?.removeWhere((e) => e.id == updatedEvent.id);
        if (events[oldDate]?.isEmpty ?? false) {
          events.remove(oldDate);
        }

        // Add to new date
        final newDate = updatedEvent.date;
        if (events[newDate] == null) {
          events[newDate] = [];
        }
        events[newDate]!.add(updatedEvent);
        update();

        Utils().showSuccessSnackBar('Success', 'Event updated successfully.');
      });
    } finally {
      clearFields();
      isLoading(false);
      EasyLoading.dismiss();
    }
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

  void clearFields() {
    titleController.clear();
    categoryController.clear();
  }

  void updateEventDetails(CalendarEvent event) {
    titleController.text = event.title;
    categoryController.text = event.category;
    selectedDay.value = event.date;
  }

  /// Reset to show all events
  void resetToShowAllEvents() {
    showAllEvents(true);
  }
}
