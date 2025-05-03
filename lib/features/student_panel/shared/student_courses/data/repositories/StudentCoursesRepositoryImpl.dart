import 'package:dartz/dartz.dart';
import '../../domain/entities/StudentCourse.dart';
import '../../domain/repositories/StudentCoursesRepository.dart';
import '../datasources/StudentCoursesRemoteDataSource.dart';

class StudentCoursesRepositoryImpl implements StudentCoursesRepository {
  final StudentCoursesRemoteDataSource remoteDataSource;

  StudentCoursesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, List<StudentCourse>>> fetchAllStudentCourses(String studentDept) async {
    try {
      final courses = await remoteDataSource.fetchAllStudentCourses(studentDept);
      return Right(courses);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}