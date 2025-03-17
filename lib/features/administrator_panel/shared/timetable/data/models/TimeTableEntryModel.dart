import '../../domain/entities/TimeTable.dart';

class TimeTableEntryModel extends TimetableEntry{
  TimeTableEntryModel({required super.id, required super.title, required super.description, required super.datePosted, String? imageUrl});

  factory TimeTableEntryModel.fromTimeTable(TimetableEntry timeTable){
    return TimeTableEntryModel(
      id: timeTable.id,
      title: timeTable.title,
      description: timeTable.description,
      datePosted: timeTable.datePosted,
      imageUrl: timeTable.imageUrl,
    );
  }

  // Convert a TimeTable object to a Map (for Firestore or JSON storage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'datePosted': datePosted.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  // Create a TimeTable object from a Map (Firestore or JSON)
  factory TimeTableEntryModel.fromMap(Map<String, dynamic> map) {
    return TimeTableEntryModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      datePosted: DateTime.parse(map['datePosted'] as String),
      imageUrl: map['imageUrl'] as String?,
    );
  }
}