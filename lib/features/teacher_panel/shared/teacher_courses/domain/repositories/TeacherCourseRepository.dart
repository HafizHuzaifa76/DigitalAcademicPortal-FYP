import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/Query.dart';
import '../entities/TeacherCourse.dart';

abstract class TeacherCourseRepository {
  Future<Either<Fail, List<TeacherCourse>>> getTeacherCourses(
      String teacherDept);
  Future<Either<Fail, Map<String, String>>> getStudentNames(
      List<dynamic> studentIds, String courseDepartment);
  Future<Either<Fail, List<Query>>> getQueries(TeacherCourse course);
  Future<Either<Fail, void>> respondToQuery(String queryId, String response, TeacherCourse course);
}
