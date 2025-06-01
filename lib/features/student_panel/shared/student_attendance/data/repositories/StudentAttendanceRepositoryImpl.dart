import 'package:dartz/dartz.dart';
import '../../domain/entities/StudentAttendance.dart';
import '../../domain/repositories/StudentAttendanceRepository.dart';
import '../data_sources/StudentAttendanceRemoteDataSource.dart';

class StudentAttendanceRepositoryImpl implements StudentAttendanceRepository {
  final StudentAttendanceRemoteDataSource remoteDataSource;

  StudentAttendanceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Fail, List<StudentAttendance>>> getStudentAttendance(String studentId, String courseId) async {
    try {
      final result = await remoteDataSource.getStudentAttendance(studentId, courseId);
      return Right(result);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, List<StudentAttendance>>> getAllAttendance(String studentId) async {
    try {
      final result = await remoteDataSource.getAllAttendance(studentId);
      return Right(result);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}