class Attendance {
  final String id;
  final String course;
  final String studentId;
  final DateTime date;
  final bool isPresent;
  final String? remarks;

  Attendance({
    required this.id,
    required this.course,
    required this.studentId,
    required this.date,
    required this.isPresent,
    this.remarks,
  });
}
