import '../../domain/entities/Attendance.dart';

class AttendanceModel extends Attendance {
  AttendanceModel({
    required String id,
    required String course,
    required String studentId,
    required DateTime date,
    required bool isPresent,
    String? remarks,
  }) : super(
          id: id,
          course: course,
          studentId: studentId,
          date: date,
          isPresent: isPresent,
          remarks: remarks,
        );

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'] as String,
      course: map['courseId'] as String,
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
