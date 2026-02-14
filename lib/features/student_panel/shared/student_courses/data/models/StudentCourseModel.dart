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
    required super.teacherID,
  });

  factory StudentCourseModel.fromMap(
    Map<String, dynamic> courseMap,
    Map<String, dynamic> sectionMap,
  ) {
    return StudentCourseModel(
      courseCode: courseMap['courseCode'] as String,
      courseName: courseMap['courseName'] as String,
      courseDept: courseMap['courseDept'] as String,
      courseSemester: courseMap['courseSemester'] as String,
      courseCreditHours: courseMap['courseCreditHours'].toInt(),
      courseType: courseMap['courseType'] as String,
      courseSection: (sectionMap['sectionName'] ?? sectionMap['courseSection']) as String,
      teacherName: sectionMap['teacherName'] ?? "No teacher",
      teacherID: sectionMap['teacherID'] ?? "No teacher ID",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'courseDept': courseDept,
      'courseSemester': courseSemester,
      'courseCreditHours': courseCreditHours,
      'courseType': courseType,
      'courseSection': courseSection,
      'teacherName': teacherName,
      'teacherID': teacherID,
    };
  }
}
