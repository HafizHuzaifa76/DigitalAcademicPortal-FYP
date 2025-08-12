import '../../domain/entities/MainNotice.dart';

class NoticeModel extends MainNotice {
  NoticeModel(
      {required super.id,
      required super.title,
      required super.description,
      required super.datePosted,
      super.imageUrl,
      super.department});

  factory NoticeModel.fromNotice(MainNotice notice) {
    var model = NoticeModel(
      id: notice.id,
      title: notice.title,
      description: notice.description,
      datePosted: notice.datePosted,
      imageUrl: notice.imageUrl,
      department: notice.department,
    );
    return model;
  }

  // Convert a Notice object to a Map (for Firestore or JSON storage)
  Map<String, dynamic> toMap() {
    print(imageUrl);
    return {
      'id': id,
      'title': title,
      'description': description,
      'datePosted': datePosted.toIso8601String(),
      'imageUrl': imageUrl,
      'department': department
    };
  }

  // Create a Notice object from a Map (Firestore or JSON)
  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      datePosted: DateTime.parse(map['datePosted'] as String),
      imageUrl: map['imageUrl'] as String?,
      department: map['department'] as String?,
    );
  }
}
