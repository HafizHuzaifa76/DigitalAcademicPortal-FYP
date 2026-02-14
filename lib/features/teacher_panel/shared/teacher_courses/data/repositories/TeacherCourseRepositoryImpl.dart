import 'package:dartz/dartz.dart';
import '../../domain/entities/TeacherCourse.dart';
import '../../domain/repositories/TeacherCourseRepository.dart';
import '../datasources/TeacherCourseRemoteDataSource.dart';
import '../../../../../../shared/domain/entities/Query.dart';

class TeacherCourseRepositoryImpl implements TeacherCourseRepository {
  final TeacherCourseRemoteDataSource remoteDataSource;

  TeacherCourseRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, List<TeacherCourse>>> getTeacherCourses(
      String teacherDept) async {
    try {
      final courses = await remoteDataSource.getTeacherCourses(teacherDept);
      return Right(courses);
    } catch (e) {
      print('Error: $e');
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, Map<String, String>>> getStudentNames(
      List<dynamic> studentIds, String courseDepartment) async {
    try {
      final studentNames =
          await remoteDataSource.getStudentNames(studentIds, courseDepartment);
      return Right(studentNames);
    } catch (e) {
      print('Error fetching student names: $e');
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, List<Query>>> getQueries(TeacherCourse course) async {
    try {
      final queries = await remoteDataSource.getQueries(course);
      return Right(queries);
    } catch (e) {
      print('Error fetching queries: $e');
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> respondToQuery(
      String queryId, String response, TeacherCourse course) async {
    try {
      await remoteDataSource.respondToQuery(queryId, response, course);
      return const Right(null);
    } catch (e) {
      print('Error responding to query: $e');
      return Left(Fail(e.toString()));
    }
  }
}
