import 'package:dartz/dartz.dart';
import '../../domain/entities/StudentGrade.dart';
import '../../domain/repositories/StudentGradeRepository.dart';
import '../data_sources/StudentGradeRemoteDataSource.dart';

class StudentGradeRepositoryImpl implements StudentGradeRepository {
  final StudentGradeRemoteDataSource remoteDataSource;

  StudentGradeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Fail, List<StudentGrade>>> getStudentGrades(
      String studentId, String courseId) async {
    try {
      final result =
          await remoteDataSource.getStudentGrades(studentId, courseId);
      return Right(result);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, List<StudentGrade>>> getAllGrades(
      String studentId) async {
    try {
      final result = await remoteDataSource.getAllGrades(studentId);
      return Right(result);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
