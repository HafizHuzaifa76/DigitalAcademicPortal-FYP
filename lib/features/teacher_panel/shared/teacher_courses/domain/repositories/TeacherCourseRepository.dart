import 'package:dartz/dartz.dart';
import '../entities/TeacherCourse.dart';

abstract class TeacherCourseRepository {
  Future<Either<Fail, List<TeacherCourse>>> getTeacherCourses(String teacherDept);
}