import 'package:dartz/dartz.dart';
import '../../../../../../shared/domain/entities/Attendance.dart';

abstract class StudentAttendanceRepository {
  Future<Either<Fail, List<Attendance>>> getStudentAttendance(String courseId);
  Future<Either<Fail, List<Attendance>>> getAllAttendance();
}
