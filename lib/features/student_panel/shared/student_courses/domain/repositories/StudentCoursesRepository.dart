import 'package:dartz/dartz.dart';
import '../entities/StudentCourse.dart';

abstract class StudentCoursesRepository {
  Future<Either<Fail, List<StudentCourse>>> fetchAllStudentCourses(String studentDept);
}