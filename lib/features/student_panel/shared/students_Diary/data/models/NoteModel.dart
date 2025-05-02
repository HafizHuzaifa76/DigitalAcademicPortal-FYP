import '../../domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({
    required super.id,
    required super.title,
    required super.content,
    required super.isCompleted,
    required super.dateTime,
  });

  factory NoteModel.fromMap(Map<String, dynamic> map, String id) {
    return NoteModel(
      id: id,
      title: map['title'],
      content: map['content'],
      isCompleted: map['isCompleted'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'content': content,
    'isCompleted': isCompleted,
    'dateTime': dateTime.toIso8601String(),
  };
}
