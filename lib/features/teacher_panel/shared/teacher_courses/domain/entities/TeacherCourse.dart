import 'package:digital_academic_portal/shared/domain/entities/SemesterCourse.dart';

class TeacherCourse extends SemesterCourse {
  final String courseSection;
  final List<dynamic> studentIds;

  TeacherCourse({
    required super.courseCode,
    required super.courseName,
    required super.courseDept,
    required super.courseSemester,
    required super.courseType,
    required super.courseCreditHours,
    required this.courseSection,
    required this.studentIds,
  });
}
