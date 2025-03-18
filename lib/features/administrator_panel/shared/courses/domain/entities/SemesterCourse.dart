
import 'DepartmentCourse.dart';

class SemesterCourse extends DepartmentCourse{
  final String courseSemester;
  final String courseType;

  SemesterCourse({required super.courseCode, required super.courseName, required super.courseDept, required this.courseSemester, required this.courseType, required super.courseCreditHours});

  factory SemesterCourse.fromDeptCourse(DepartmentCourse deptCourse, String semester, String courseType){
    return SemesterCourse(
        courseCode: deptCourse.courseCode,
        courseName: deptCourse.courseName,
        courseDept: deptCourse.courseDept,
        courseSemester: semester,
        courseType: courseType,
        courseCreditHours: deptCourse.courseCreditHours
    );
  }
}
