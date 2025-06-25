class PreviousCourseGrade {
  final String courseCode;
  final String course;
  final String studentId;
  final double sessionalMarks;
  final double finalMarks;
  final double totalMarks;
  final String grade;
  final int credithour;
  final double gpa;
  final String status;
  final String semester;
  final String? remarks;

  PreviousCourseGrade({
    required this.courseCode,
    required this.course,
    required this.studentId,
    required this.sessionalMarks,
    required this.finalMarks,
    required this.totalMarks,
    required this.grade,
    required this.credithour,
    required this.gpa,
    required this.status,
    required this.semester,
    this.remarks,
  });
}
