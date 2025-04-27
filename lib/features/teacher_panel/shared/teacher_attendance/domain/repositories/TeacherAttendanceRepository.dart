import 'package:dartz/dartz.dart';
import '../entities/TeacherAttendance.dart';

abstract class TeacherAttendanceRepository {
  Future<Either<Fail, List<TeacherAttendance>>> getTeacherAttendance();
}