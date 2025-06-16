import '../../domain/entities/Note.dart';

class NoteModel extends Note {
  NoteModel({
    required super.id,
    required super.title,
    required super.content,
    required super.isCompleted,
    required super.dateTime,
    super.priority,
    super.category,
    super.dueDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'isCompleted': isCompleted,
        'dateTime': dateTime,
        'priority': priority,
        'category': category,
        'dueDate': dueDate,
      };

  factory NoteModel.fromJson(Map<String, dynamic> json, String id) => NoteModel(
        id: id,
        title: json['title'],
        content: json['content'],
        isCompleted: json['isCompleted'],
        dateTime: json['dateTime'],
        priority: json['priority'],
        category: json['category'],
        dueDate: json['dueDate'],
      );

  factory NoteModel.fromEntity(Note note) => NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        isCompleted: note.isCompleted,
        dateTime: note.dateTime,
        priority: note.priority,
        category: note.category,
        dueDate: note.dueDate,
      );

  factory NoteModel.withId(Note note, String id) => NoteModel(
        id: id,
        title: note.title,
        content: note.content,
        isCompleted: note.isCompleted,
        dateTime: note.dateTime,
        priority: note.priority,
        category: note.category,
        dueDate: note.dueDate,
      );
}
