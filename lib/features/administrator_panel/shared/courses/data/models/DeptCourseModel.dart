import 'package:digital_academic_portal/features/administrator_panel/shared/courses/domain/entities/DepartmentCourse.dart';

class DeptCourseModel extends DepartmentCourse{
  DeptCourseModel({required super.courseCode, required super.courseName, required super.courseDept, required super.courseCreditHours});

  Map<String, dynamic> toMap() {
    return {
      'courseCode': courseCode,
      'courseName': courseName,
      'courseDept': courseDept,
      'courseCreditHours': courseCreditHours,
    };
  }

  factory DeptCourseModel.fromMap(Map<String, dynamic> map) {
    return DeptCourseModel(
      courseCode: map['courseCode'] as String,
      courseName: map['courseName'] as String,
      courseDept: map['courseDept'] as String,
      courseCreditHours: map['courseCreditHours'].toInt(),
    );
  }

  factory DeptCourseModel.fromCourse(DepartmentCourse course){
    return DeptCourseModel(
        courseCode: course.courseCode,
        courseName: course.courseName,
        courseDept: course.courseDept,
        courseCreditHours: course.courseCreditHours,
    );
  }
}
