import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_academic_portal/shared/data/models/CalendarEventModel.dart';
import 'package:digital_academic_portal/shared/domain/entities/CalendarEvent.dart';

abstract class TeacherCalendarEventRemoteDataSource {
  Future<Map<DateTime, List<CalendarEvent>>> getAllEvents();
}

class TeacherCalendarEventRemoteDataSourceImpl
    implements TeacherCalendarEventRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Map<DateTime, List<CalendarEvent>>> getAllEvents() async {
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
