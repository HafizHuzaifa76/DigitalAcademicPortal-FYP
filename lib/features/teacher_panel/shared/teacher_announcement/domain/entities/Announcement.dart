class Announcement {
  final String id;
  final String title;
  final String content;
  final DateTime dateTime;
  final bool isPublished;
  final String courseId;
  final String courseName;
  final String courseSection;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.dateTime,
    this.isPublished = true,
    required this.courseId,
    required this.courseName,
    required this.courseSection,
  });
}
