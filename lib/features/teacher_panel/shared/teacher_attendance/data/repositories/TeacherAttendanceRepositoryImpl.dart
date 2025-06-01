import 'package:dartz/dartz.dart';
import '../../domain/repositories/TeacherAttendanceRepository.dart';
import '../datasources/TeacherAttendanceRemoteDataSource.dart';
import '../../domain/entities/TeacherAttendance.dart';
import '../models/TeacherAttendanceModel.dart';

class TeacherAttendanceRepositoryImpl implements TeacherAttendanceRepository {
  final TeacherAttendanceRemoteDataSource remoteDataSource;

  TeacherAttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Fail, List<TeacherAttendance>>> getTeacherAttendance() async {
    // Implementation will go here
    throw UnimplementedError();
  }

  @override
  Future<Either<Fail, List<TeacherAttendance>>> getAttendanceForDate(
      String courseId, String courseSection, DateTime date) async {
    try {
      final result = await remoteDataSource.getAttendanceForDate(
          courseId, courseSection, date);
      return Right(result);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }

  @override
  Future<Either<Fail, void>> markAttendance(
      List<TeacherAttendance> attendanceList) async {
    try {
      await remoteDataSource.markAttendance(attendanceList
          .map((e) => TeacherAttendanceModel(
                id: e.id,
                courseId: e.courseId,
                studentId: e.studentId,
                date: e.date,
                isPresent: e.isPresent,
                courseSection: e.courseSection,
                remarks: e.remarks,
              ))
          .toList());
      return const Right(null);
    } catch (e) {
      return Left(Fail(e.toString()));
    }
  }
}
