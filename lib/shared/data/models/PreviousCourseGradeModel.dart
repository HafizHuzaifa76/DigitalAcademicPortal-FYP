import '../../domain/entities/PreviousCourseGrade.dart';

class PreviousCourseGradeModel extends PreviousCourseGrade {
  PreviousCourseGradeModel({
    required String courseCode,
    required String course,
    required String studentId,
    required double sessionalMarks,
    required double finalMarks,
    required double totalMarks,
    required String grade,
    required int credithour,
    required double gpa,
    required String status,
    required String semester,
    String? remarks,
  }) : super(
            courseCode: courseCode,
            course: course,
            studentId: studentId,
            sessionalMarks: sessionalMarks,
            finalMarks: finalMarks,
            totalMarks: totalMarks,
            grade: grade,
            status: status,
            semester: semester,
            remarks: remarks,
            credithour: credithour,
            gpa: gpa
  );

  factory PreviousCourseGradeModel.fromMap(Map<String, dynamic> map) {
    return PreviousCourseGradeModel(
      courseCode: map['courseCode'] as String,
      course: map['course'] as String,
      studentId: map['studentId'] as String,
      sessionalMarks: (map['sessionalMarks'] as num).toDouble(),
      finalMarks: (map['finalMarks'] as num).toDouble(),
      totalMarks: (map['totalMarks'] as num).toDouble(),
      grade: map['grade'] as String,
      credithour: map['credithour'] as int,
      gpa: (map['gpa'] as num).toDouble(),
      status: map['status'] as String,
      semester: map['semester'] as String,
      remarks: map['remarks'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'course': course,
      'studentId': studentId,
      'sessionalMarks': sessionalMarks,
      'finalMarks': finalMarks,
      'totalMarks': totalMarks,
      'grade': grade,
      'credithour': credithour,
      'gpa': gpa,
      'status': status,
      'semester': semester,
      'remarks': remarks,
    };
  }
}
