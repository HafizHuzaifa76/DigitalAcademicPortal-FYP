import '../../domain/entities/SemesterCourse.dart';

class SemesterCourseModel extends SemesterCourse{
  SemesterCourseModel({required super.courseCode, required super.courseName, required super.courseDept, required super.courseCreditHours, required super.courseSemester, required super.courseType});

  factory SemesterCourseModel.fromCourse(SemesterCourse course){
    return SemesterCourseModel(
        courseCode: course.courseCode,
        courseName: course.courseName,
        courseDept: course.courseDept,
        courseType: course.courseType,
        courseCreditHours: course.courseCreditHours,
        courseSemester: course.courseSemester
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'courseDept': courseDept,
      'courseType': courseType,
      'courseSemester': courseSemester,
      'courseCreditHours': courseCreditHours,
    };
  }

  factory SemesterCourseModel.fromMap(Map<String, dynamic> map) {
    return SemesterCourseModel(
      courseCode: map['courseCode'] as String,
      courseName: map['courseName'] as String,
      courseDept: map['courseDept'] as String,
      courseType: map['courseType'] as String,
      courseSemester: map['courseSemester'] as String,
      courseCreditHours: map['courseCreditHours'].toInt(),
    );
  }

}