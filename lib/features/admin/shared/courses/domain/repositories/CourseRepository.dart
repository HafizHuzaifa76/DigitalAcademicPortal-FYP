
import 'package:dartz/dartz.dart';
import '../entities/Course.dart';

abstract class CourseRepository{

  Future<Either<Fail, Course>> addCourse(String deptName, Course course);
  Future<Either<Fail, Course>> editCourse(String deptName, Course course);
  Future<Either<Fail, void>> deleteCourse(String deptName, Course course);
  Future<Either<Fail, List<Course>>> showDeptCourses(String deptName);
  Future<Either<Fail, List<Course>>> showSemesterCourses(String deptName, String semester);
  Future<Either<Fail, List<Course>>> showAllCourses();

}