import '../../domain/entities/CalendarEvent.dart';

class CalendarEventModel extends CalendarEvent {

  CalendarEventModel({
    required super.id,
    required super.title,
    required super.date,
    required super.category,
  });

  // Convert Firestore document to model
  factory CalendarEventModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CalendarEventModel(
      id: id,
      title: data['title'],
      category: data['category'],
      date: DateTime.parse(data['date']),
    );
  }

  // Convert model to Firestore-compatible map
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'category': category,
      'date': date.toIso8601String(),
    };
  }

  // Convert domain entity to model
  factory CalendarEventModel.fromEntity(CalendarEvent event) {
    return CalendarEventModel(
      id: event.id,
      title: event.title,
      date: event.date,
      category: event.category
    );
  }

  // Convert model to domain entity
  CalendarEvent toEntity() {
    return CalendarEvent(
      id: id,
      title: title,
      date: date,
      category: category,
    );
  }
}
