import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digital_academic_portal/shared/domain/entities/CalendarEvent.dart';
import 'package:digital_academic_portal/shared/data/models/CalendarEventModel.dart';

abstract class StudentCalendarEventRemoteDataSource {
  Future<Map<DateTime, List<CalendarEvent>>> getAllEvents();
}

class StudentCalendarEventRemoteDataSourceImpl
    implements StudentCalendarEventRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<Map<DateTime, List<CalendarEvent>>> getAllEvents() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception('No user logged in');

      final QuerySnapshot snapshot =
          await _firestore.collection('calendar_events').get();

      Map<DateTime, List<CalendarEvent>> eventMap = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final event = CalendarEventModel.fromFirestore(data, doc.id);
        final date =
            DateTime(event.date.year, event.date.month, event.date.day);

        if (!eventMap.containsKey(date)) {
          eventMap[date] = [];
        }
        eventMap[date]!.add(event);
      }

      print(eventMap.length);
      return eventMap;
    } catch (e) {
      throw Exception('Failed to fetch events: $e');
    }
  }
}
