import '../../domain/entities/PreviousCourseGrade.dart';

class PreviousCourseGradeModel extends PreviousCourseGrade {
  PreviousCourseGradeModel({
    required String id,
    required String courseId,
    required String studentId,
    required double sessionalMarks,
    required double finalMarks,
    required double totalMarks,
    required String eligibility,
    required String status,
    required String semester,
    String? remarks,
  }) : super(
          id: id,
          course: courseId,
          studentId: studentId,
          sessionalMarks: sessionalMarks,
          finalMarks: finalMarks,
          totalMarks: totalMarks,
          eligibility: eligibility,
          status: status,
          semester: semester,
          remarks: remarks,
        );

  factory PreviousCourseGradeModel.fromMap(Map<String, dynamic> map) {
    return PreviousCourseGradeModel(
      id: map['id'] as String,
      courseId: map['courseId'] as String,
      studentId: map['studentId'] as String,
      sessionalMarks: (map['sessionalMarks'] as num).toDouble(),
      finalMarks: (map['finalMarks'] as num).toDouble(),
      totalMarks: (map['totalMarks'] as num).toDouble(),
      eligibility: map['eligibility'] as String,
      status: map['status'] as String,
      semester: map['semester'] as String,
      remarks: map['remarks'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': course,
      'studentId': studentId,
      'sessionalMarks': sessionalMarks,
      'finalMarks': finalMarks,
      'totalMarks': totalMarks,
      'eligibility': eligibility,
      'status': status,
      'semester': semester,
      'remarks': remarks,
    };
  }
}
