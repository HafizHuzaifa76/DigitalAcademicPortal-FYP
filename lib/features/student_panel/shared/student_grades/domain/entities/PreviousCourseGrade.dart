class PreviousCourseGrade {
  final String id;
  final String course;
  final String studentId;
  final double sessionalMarks;
  final double finalMarks;
  final double totalMarks;
  final String eligibility;
  final String status;
  final String semester;
  final String? remarks;

  PreviousCourseGrade({
    required this.id,
    required this.course,
    required this.studentId,
    required this.sessionalMarks,
    required this.finalMarks,
    required this.totalMarks,
    required this.eligibility,
    required this.status,
    required this.semester,
    this.remarks,
  });
}
