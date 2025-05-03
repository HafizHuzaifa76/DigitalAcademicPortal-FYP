import 'package:digital_academic_portal/shared/domain/entities/SemesterCourse.dart';

class StudentCourse extends SemesterCourse {
  final String courseSection;
  final String teacherName;
  final String teacherEmail;

  StudentCourse({
    required super.courseCode,
    required super.courseName,
    required super.courseDept,
    required super.courseSemester,
    required super.courseType,
    required super.courseCreditHours,
    required this.courseSection,
    required this.teacherName,
    required this.teacherEmail,
  });
}