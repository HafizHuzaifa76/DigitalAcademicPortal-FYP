class StudentAssignment {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String fileUrl;
  final String courseId;
  final String courseName;
  final String status; // 'Not Uploaded', 'Uploaded', 'Submitted'
  final String? submittedFileUrl;
  final DateTime? submittedAt;

  StudentAssignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.fileUrl,
    required this.courseId,
    required this.courseName,
    required this.status,
    this.submittedFileUrl,
    this.submittedAt,
  });
}
