import 'package:dartz/dartz.dart';
import '../../domain/entities/StudentAttendance.dart';
import '../../domain/repositories/StudentAttendanceRepository.dart';
import '../data_sources/StudentAttendanceRemoteDataSource.dart';

class StudentAttendanceRepositoryImpl implements StudentAttendanceRepository {
  final StudentAttendanceRemoteDataSource remoteDataSource;

  StudentAttendanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Fail, List<StudentAttendance>>> getStudentAttendance(
      String courseId) async {
    try {
      final result = await remoteDataSource.getStudentAttendance(courseId);
      return Right(result);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, List<StudentAttendance>>> getAllAttendance() async {
    try {
      final result = await remoteDataSource.getAllAttendance();
      return Right(result);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
