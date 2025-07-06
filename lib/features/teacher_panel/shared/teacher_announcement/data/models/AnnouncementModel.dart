import '../../domain/entities/Announcement.dart';

class AnnouncementModel extends Announcement {
  AnnouncementModel({
    required super.id,
    required super.title,
    required super.content,
    required super.dateTime,
    super.isPublished = true,
    required super.courseId,
    required super.courseName,
    required super.courseSection,
  });

  factory AnnouncementModel.fromMap(
      Map<String, dynamic> map, String documentId) {
    return AnnouncementModel(
      id: documentId,
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      dateTime: map['dateTime']?.toDate() ?? DateTime.now(),
      isPublished: map['isPublished'] ?? true,
      courseId: map['courseId'] ?? '',
      courseName: map['courseName'] ?? '',
      courseSection: map['courseSection'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'dateTime': dateTime,
      'isPublished': isPublished,
      'courseId': courseId,
      'courseName': courseName,
      'courseSection': courseSection,
    };
  }
}
