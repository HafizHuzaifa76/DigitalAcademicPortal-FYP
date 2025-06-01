import '../../domain/entities/TeacherCourse.dart';

class TeacherCourseModel extends TeacherCourse {
  TeacherCourseModel({
    required super.courseCode,
    required super.courseName,
    required super.courseDept,
    required super.courseSemester,
    required super.courseType,
    required super.courseCreditHours,
    required super.courseSection,
    required super.studentIds,
  });

  factory TeacherCourseModel.fromMap(Map<String, dynamic> map) {
    return TeacherCourseModel(
      courseCode: map['courseCode'] as String,
      courseName: map['courseName'] as String,
      courseDept: map['courseDept'] as String,
      courseType: map['courseType'] as String,
      courseSemester: map['courseSemester'] as String,
      courseCreditHours: map['courseCreditHours'].toInt(),
      courseSection: map['courseSection'] as String,
      studentIds: map['studentIds'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'courseDept': courseDept,
      'courseSemester': courseSemester,
      'courseCreditHours': courseCreditHours,
      'courseSection': courseSection,
      'courseType': courseType,
      'studentIds': studentIds,
    };
  }
}
