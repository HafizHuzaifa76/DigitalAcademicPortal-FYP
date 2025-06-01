import 'package:dartz/dartz.dart';
import '../entities/StudentAttendance.dart';

abstract class StudentAttendanceRepository {
  Future<Either<Fail, List<StudentAttendance>>> getStudentAttendance(
      String courseId);
  Future<Either<Fail, List<StudentAttendance>>> getAllAttendance();
}
