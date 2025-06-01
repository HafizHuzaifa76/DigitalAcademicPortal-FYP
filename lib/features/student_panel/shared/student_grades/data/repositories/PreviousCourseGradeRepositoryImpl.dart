import 'package:dartz/dartz.dart';
import '../../domain/entities/PreviousCourseGrade.dart';
import '../../domain/repositories/PreviousCourseGradeRepository.dart';
import '../data_sources/PreviousCourseGradeRemoteDataSource.dart';

class PreviousCourseGradeRepositoryImpl
    implements PreviousCourseGradeRepository {
  final PreviousCourseGradeRemoteDataSource remoteDataSource;

  PreviousCourseGradeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Fail, List<PreviousCourseGrade>>> getPreviousCourseGrades(
      String studentId) async {
    try {
      final result = await remoteDataSource.getPreviousCourseGrades(studentId);
      return Right(result);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, List<PreviousCourseGrade>>> getPreviousSemesterGrades(
      String studentId, String semester) async {
    try {
      final result =
          await remoteDataSource.getPreviousSemesterGrades(studentId, semester);
      return Right(result);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
