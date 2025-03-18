
import 'package:dartz/dartz.dart';
import 'package:digital_academic_portal/features/administrator_panel/shared/courses/domain/entities/DepartmentCourse.dart';
import '../entities/SemesterCourse.dart';

abstract class CourseRepository{

  Future<Either<Fail, DepartmentCourse>> addCourse(String deptName, DepartmentCourse course);
  Future<Either<Fail, void>> addCourseList(List<DepartmentCourse> courses);
  Future<Either<Fail, List<SemesterCourse>>> addSemesterCoursesList(List<SemesterCourse> courses);
  Future<Either<Fail, DepartmentCourse>> editCourse(String deptName, DepartmentCourse course);
  Future<Either<Fail, void>> deleteCourse(String deptName, DepartmentCourse course);
  Future<Either<Fail, List<DepartmentCourse>>> showDeptCourses(String deptName);
  Future<Either<Fail, List<SemesterCourse>>> showSemesterCourses(String deptName, String semester);
  Future<Either<Fail, List<SemesterCourse>>> showAllSemesterCourses(String deptName);

}