import '../../domain/entities/TeacherAttendance.dart';

class TeacherAttendanceModel extends TeacherAttendance {
  TeacherAttendanceModel({
    required String id,
    required String courseId,
    required String studentId,
    required DateTime date,
    required bool isPresent,
    required String courseSection,
    String? remarks,
  }) : super(
          id: id,
          courseId: courseId,
          studentId: studentId,
          date: date,
          isPresent: isPresent,
          courseSection: courseSection,
          remarks: remarks,
        );

  factory TeacherAttendanceModel.fromMap(Map<String, dynamic> map) {
    return TeacherAttendanceModel(
      id: map['id'] as String,
      courseId: map['courseId'] as String,
      studentId: map['studentId'] as String,
      date: DateTime.parse(map['date'] as String),
      isPresent: map['isPresent'] as bool,
      courseSection: map['courseSection'] as String,
      remarks: map['remarks'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': courseId,
      'studentId': studentId,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
      'courseSection': courseSection,
      'remarks': remarks,
    };
  }
}
