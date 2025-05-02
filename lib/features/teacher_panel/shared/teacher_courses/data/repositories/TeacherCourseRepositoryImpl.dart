import 'package:dartz/dartz.dart';
import '../../domain/entities/TeacherCourse.dart';
import '../../domain/repositories/TeacherCourseRepository.dart';
import '../datasources/TeacherCourseRemoteDataSource.dart';

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
}
