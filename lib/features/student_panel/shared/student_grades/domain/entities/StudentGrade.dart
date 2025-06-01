class StudentGrade {
  final String id;
  final String course;
  final String studentId;
  final String grade;
  final double marks;
  final double totalMarks;
  final String category; // Assignment, Quiz, Mid, etc.
  final String semester;
  final String? remarks;

  StudentGrade({
    required this.id,
    required this.course,
    required this.studentId,
    required this.grade,
    required this.marks,
    required this.totalMarks,
    required this.category,
    required this.semester,
    this.remarks,
  });
}
