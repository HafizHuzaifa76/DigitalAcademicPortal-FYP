import '../../domain/entities/Course.dart';

class CourseModel extends Course{
  CourseModel({required super.courseCode, required super.courseName, required super.courseDept, required super.courseCreditHours, required super.courseSemester, required super.courseType});

  factory CourseModel.fromCourse(Course course){
    return CourseModel(
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

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      courseCode: map['courseCode'] as String,
      courseName: map['courseName'] as String,
      courseDept: map['courseDept'] as String,
      courseType: map['courseType'] as String,
      courseSemester: map['courseSemester'] as String,
      courseCreditHours: map['courseCreditHours'].toDouble(),
    );
  }

}