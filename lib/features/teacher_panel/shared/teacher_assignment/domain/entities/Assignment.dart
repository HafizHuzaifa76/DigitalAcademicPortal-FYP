class Assignment {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final String fileUrl;
  final Map<String, dynamic> studentAssignments;

  Assignment({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.fileUrl,
    required this.studentAssignments,
  });
}
