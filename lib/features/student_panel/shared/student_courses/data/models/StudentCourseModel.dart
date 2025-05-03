import '../../domain/entities/StudentCourse.dart';

class StudentCourseModel extends StudentCourse {
  StudentCourseModel({
    required super.courseCode,
    required super.courseName,
    required super.courseDept,
    required super.courseSemester,
    required super.courseType,
    required super.courseCreditHours,
    required super.courseSection,
    required super.teacherName,
    required super.teacherEmail,
  });

  factory StudentCourseModel.fromMap(Map<String, dynamic> map) {
    return StudentCourseModel(
      courseCode: map['courseCode'] as String,
      courseName: map['courseName'] as String,
      courseDept: map['courseDept'] as String,
      courseType: map['courseType'] as String,
      courseSemester: map['courseSemester'] as String,
      courseCreditHours: map['courseCreditHours'].toInt(),
      courseSection: map['courseSection'] as String,
      teacherName: map['teacherName'] as String,
      teacherEmail: map['teacherEmail'] as String,
    );
  }
}