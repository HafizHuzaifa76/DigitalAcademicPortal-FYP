import 'package:dartz/dartz.dart';
import '../entities/TeacherAttendance.dart';

abstract class TeacherAttendanceRepository {
  Future<Either<Fail, List<TeacherAttendance>>> getAttendanceForDate(
      String courseId, String courseSection, DateTime date);
  Future<Either<Fail, void>> markAttendance(
      List<TeacherAttendance> attendanceList);
}
