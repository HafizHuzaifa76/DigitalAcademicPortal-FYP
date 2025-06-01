class TeacherAttendance {
  final String id;
  final String courseId;
  final String studentId;
  final DateTime date;
  final bool isPresent;
  final String? remarks;
  final String courseSection;

  TeacherAttendance({
    required this.id,
    required this.courseId,
    required this.studentId,
    required this.date,
    required this.isPresent,
    required this.courseSection,
    this.remarks,
  });
}
