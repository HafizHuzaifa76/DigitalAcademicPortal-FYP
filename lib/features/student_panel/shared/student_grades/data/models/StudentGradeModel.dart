import '../../domain/entities/StudentGrade.dart';

class StudentGradeModel extends StudentGrade {
  StudentGradeModel({
    required String id,
    required String courseId,
    required String studentId,
    required String grade,
    required double marks,
    required double totalMarks,
    required String category,
    required String semester,
    String? remarks,
  }) : super(
          id: id,
          course: courseId,
          studentId: studentId,
          grade: grade,
          marks: marks,
          totalMarks: totalMarks,
          category: category,
          semester: semester,
          remarks: remarks,
        );

  factory StudentGradeModel.fromMap(Map<String, dynamic> map) {
    return StudentGradeModel(
      id: map['id'] as String,
      courseId: map['courseId'] as String,
      studentId: map['studentId'] as String,
      grade: map['grade'] as String,
      marks: (map['marks'] as num).toDouble(),
      totalMarks: (map['totalMarks'] as num).toDouble(),
      category: map['category'] as String,
      semester: map['semester'] as String,
      remarks: map['remarks'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': course,
      'studentId': studentId,
      'grade': grade,
      'marks': marks,
      'totalMarks': totalMarks,
      'category': category,
      'semester': semester,
      'remarks': remarks,
    };
  }
}
