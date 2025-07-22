
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../../shared/domain/entities/CalendarEvent.dart';
import '../../../../../../shared/data/models/CalendarEventModel.dart';

abstract class CalendarEventRemoteDataSource{
  Future<CalendarEventModel> addCalendarEvent(CalendarEventModel department);
  Future<CalendarEventModel> editCalendarEvent(CalendarEventModel department);
  Future<void> deleteCalendarEvent(String departmentName);
  Future<Map<DateTime, List<CalendarEvent>>> allCalendarEvents();
}

class CalendarEventRemoteDataSourceImpl implements CalendarEventRemoteDataSource{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  // Add a new calendar event
  Future<CalendarEventModel> addCalendarEvent(CalendarEventModel event) async {
    print('time');
    print(event.date);
    var eventMap = event.toFirestore();
    print('eventMap');
    print(eventMap);
    final docRef = await _firestore.collection('calendar_events').add(eventMap);
    return CalendarEventModel.fromFirestore(eventMap, docRef.id);
  }

  // Edit an existing calendar event
  @override
  Future<CalendarEventModel> editCalendarEvent(CalendarEventModel event) async {
    await _firestore.collection('calendar_events').doc(event.id).update(event.toFirestore());
    return event;
  }

  // Delete a calendar event
  @override
  Future<void> deleteCalendarEvent(String id) async {
    await _firestore.collection('calendar_events').doc(id).delete();
  }

  // Fetch all calendar events
  @override
  Future<Map<DateTime, List<CalendarEvent>>> allCalendarEvents() async {
    final snapshot = await _firestore.collection('calendar_events').get();
    final eventMap = <DateTime, List<CalendarEvent>>{};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final eventDate = DateTime.parse(data['date']);
      final event = CalendarEvent(
        id: doc.id,
        title: data['title'],
        date: eventDate,
        category: data['category'],
      );

      if (eventMap[eventDate] == null) {
        eventMap[eventDate] = [];
      }
      eventMap[eventDate]!.add(event);
    }

    return eventMap;
  }

}