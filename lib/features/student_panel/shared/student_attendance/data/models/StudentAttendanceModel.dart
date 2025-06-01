import '../../domain/entities/StudentAttendance.dart';

class StudentAttendanceModel extends StudentAttendance {
  StudentAttendanceModel({
    required String id,
    required String courseId,
    required String studentId,
    required DateTime date,
    required bool isPresent,
    String? remarks,
  }) : super(
          id: id,
          course: courseId,
          studentId: studentId,
          date: date,
          isPresent: isPresent,
          remarks: remarks,
        );

  factory StudentAttendanceModel.fromMap(Map<String, dynamic> map) {
    return StudentAttendanceModel(
      id: map['id'] as String,
      courseId: map['courseId'] as String,
      studentId: map['studentId'] as String,
      date: DateTime.parse(map['date'] as String),
      isPresent: map['isPresent'] as bool,
      remarks: map['remarks'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseId': course,
      'studentId': studentId,
      'date': date.toIso8601String(),
      'isPresent': isPresent,
      'remarks': remarks,
    };
  }
}
